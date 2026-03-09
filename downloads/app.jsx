import React, {
    useState,
    useEffect,
    useReducer,
    useCallback,
    useRef,
    useMemo,
    createContext,
    useContext
} from 'react';
import { initializeApp } from 'firebase/app';
import {
    getAuth,
    signInAnonymously,
    signInWithCustomToken,
    onAuthStateChanged
} from 'firebase/auth';
import {
    getFirestore,
    doc,
    setDoc,
    onSnapshot
} from 'firebase/firestore';
import {
    ArrowLeft,
    ArrowRight,
    Grid,
    Layout,
    BookOpen,
    Trash2,
    Maximize,
    Minimize,
    Search,
    Check,
    X,
    Move,
    Palette
} from 'lucide-react';

// --- 0. FIREBASE SETUP & ENVIRONMENT GLOBALS ---

// Global variables provided by the environment
const appId = typeof __app_id !== 'undefined' ? __app_id : 'default-app-id';
const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : {};
const initialAuthToken = typeof __initial_auth_token !== 'undefined' ? __initial_auth_token : undefined;

// Initialize Firebase services
const app = Object.keys(firebaseConfig).length > 0 ? initializeApp(firebaseConfig) : null;
const db = app ? getFirestore(app) : null;
const auth = app ? getAuth(app) : null;

const docPath = (userId) => `artifacts/${appId}/users/${userId}/design/gardenDesign`;


// --- 1. UTILITIES & CONSTANTS (src/utils/plantUtils.js & src/utils/constants.js) ---

export const DESIGN_STEPS = {
    INPUT: '1. Constraints & Goals',
    LAYOUT: '2. Design & Simulate Growth',
    REVIEW: '3. Final Plan & Export',
};
const STEP_KEYS = Object.keys(DESIGN_STEPS);

export const generatePlantId = () => `p_${Date.now()}_${Math.floor(Math.random() * 1000)}`;

/**
 * Calculates the current plant radius based on growth simulation time.
 */
export const getCurrentRadius = (plant, year) => {
    const { matureRadius, growthRate } = plant;
    // Safely get initial radius, defaulting to 0.5m if missing
    const initialRadius = plant.placement?.initialRadius ?? 0.5;

    if (typeof matureRadius !== 'number' || typeof growthRate !== 'number')
        return initialRadius;

    // Growth is simulated as a factor of year, capped at 1 (full maturity)
    const factor = Math.min(1, growthRate * year);
    // Linear interpolation between initial and mature radius
    const radius = initialRadius + (matureRadius - initialRadius) * factor;

    // Ensure radius is positive and capped by mature size
    return Math.max(0.1, Math.min(radius, matureRadius));
};

/**
 * Calculates the overlap distance between two plants.
 */
export const calculateOverlap = (p1, p2, year) => {
    if (!p1.placement || !p2.placement) return 0;

    const r1 = getCurrentRadius(p1, year);
    const r2 = getCurrentRadius(p2, year);

    const dx = p1.placement.x - p2.placement.x;
    const dy = p1.placement.y - p2.placement.y;
    const distance = Math.sqrt(dx * dx + dy * dy);

    // Overlap is (R1 + R2) - Distance. A positive value means overlap.
    return (r1 + r2) - distance;
};


// --- 2. REDUCER & INITIAL STATE (src/reducers/designReducer.js) ---

export const initialState = {
    // Firebase/Auth Status
    userId: null,
    isAuthReady: false,
    error: null,
    isLoading: false,

    // Step Navigation
    designStep: DESIGN_STEPS.INPUT,

    // Step 1: Constraints (yardConfig)
    yardConfig: {
        width: 10,
        height: 10,
        unit: 'm',
        sunExposure: 'Full Sun',
        soilType: 'Loam',
        hardinessZone: '8a' // Added zone for AI context
    },

    // Step 2: Design & Simulation
    catalog: [
        { id: 1, commonName: 'Rose Bush', initialRadius: 0.3, matureRadius: 0.8, growthRate: 0.1, color: '#f87171' }, // Red/Pink
        { id: 2, commonName: 'Lavender', initialRadius: 0.2, matureRadius: 0.5, growthRate: 0.2, color: '#a78bfa' }, // Purple
        { id: 3, commonName: 'Dwarf Maple', initialRadius: 0.4, matureRadius: 1.5, growthRate: 0.05, color: '#fcd34d' }, // Yellow/Orange
        { id: 4, commonName: 'Stonecrop', initialRadius: 0.1, matureRadius: 0.3, growthRate: 0.3, color: '#6ee7b7' }, // Light Green
    ],
    growthYear: 1, // Current year for simulation (1 to 20)

    // Current Design (Plants, AI feedback, Cost)
    currentDesign: {
        plants: [], // [{ id, catalogId, commonName, matureRadius, placement: { x, y, initialRadius } }]
        designSummary: 'Define your yard constraints and click "Generate Initial Plan" to start.',
        estimatedCost: 0,
        aiLog: [],
    },
};

const designReducer = (state, action) => {
    switch (action.type) {
        // --- System & Auth ---
        case 'SET_AUTH_READY':
            return { ...state, isAuthReady: true, userId: action.payload };
        case 'SET_ERROR':
            return { ...state, error: action.payload };
        case 'CLEAR_ERROR':
            return { ...state, error: null };
        case 'SET_LOADING':
            return { ...state, isLoading: action.payload };

        // --- Navigation ---
        case 'SET_STEP':
            return { ...state, designStep: action.payload, error: null };

        // --- Step 1: Yard Input ---
        case 'UPDATE_YARD_CONFIG':
            return {
                ...state,
                yardConfig: {
                    ...state.yardConfig,
                    [action.field]: action.value
                }
            };

        // --- Step 2: Design & Simulation ---
        case 'SET_GROWTH_YEAR':
            return { ...state, growthYear: action.payload };
        case 'UPDATE_PLANT_PLACEMENT':
            return {
                ...state,
                currentDesign: {
                    ...state.currentDesign,
                    plants: state.currentDesign.plants.map(p =>
                        p.id === action.payload.id ? { ...p, placement: action.payload.placement } : p
                    ),
                },
            };
        case 'REMOVE_PLANT':
            return {
                ...state,
                currentDesign: {
                    ...state.currentDesign,
                    plants: state.currentDesign.plants.plants.filter(p => p.id !== action.payload)
                }
            };

        // --- AI Refinement / Firestore Load ---
        case 'UPDATE_DESIGN':
            return {
                ...state,
                currentDesign: {
                    ...state.currentDesign,
                    plants: action.payload.plants || state.currentDesign.plants,
                    designSummary: action.payload.designSummary || state.currentDesign.designSummary,
                    estimatedCost: action.payload.estimatedCost || state.currentDesign.estimatedCost,
                    aiLog: action.payload.aiLog || state.currentDesign.aiLog,
                }
            };
        case 'SET_STATE_FROM_FIRESTORE':
            // Merge Firestore data, excluding volatile fields like step
            const { designStep, growthYear, ...firestoreData } = action.payload;
            return {
                ...state,
                ...firestoreData,
                // Ensure designStep is preserved for navigation
                designStep: state.designStep,
                growthYear: state.growthYear,
                // Ensure the data structure is correct even if partial
                yardConfig: { ...initialState.yardConfig, ...(firestoreData.yardConfig || {}) },
                currentDesign: { ...initialState.currentDesign, ...(firestoreData.currentDesign || {}) },
            };
        default:
            return state;
    }
};


// --- 3. CONTEXT & GLOBAL STATE HOOK (src/hooks/useDesignState.js) ---

const DesignContext = createContext(null);

const DesignProvider = ({ children }) => {
    const [state, dispatch] = useReducer(designReducer, initialState);

    // --- Firebase Sync/Save Logic (side effect) ---

    // Effect for Firebase Initialization and Authentication
    useEffect(() => {
        if (!auth) {
            // Mock authentication if Firebase isn't configured
            console.error("Firebase Auth not initialized. Running in Mock Mode.");
            dispatch({ type: 'SET_AUTH_READY', payload: 'MockUser' });
            return;
        }

        const unsubscribeAuth = onAuthStateChanged(auth, async (user) => {
            if (!user) {
                // Sign in anonymously if no token is provided
                try {
                    if (initialAuthToken) {
                        await signInWithCustomToken(auth, initialAuthToken);
                    } else {
                        await signInAnonymously(auth);
                    }
                } catch (e) {
                    console.error("Auth failed:", e);
                    dispatch({ type: 'SET_ERROR', payload: `Authentication failed: ${e.message}` });
                }
            }
            const userId = auth.currentUser?.uid || 'Anon';
            dispatch({ type: 'SET_AUTH_READY', payload: userId });
        });

        return () => unsubscribeAuth();
    }, []);

    // Effect for Real-time Firestore Listener
    useEffect(() => {
        if (!db || !state.isAuthReady || !state.userId || state.userId === 'Anon') {
            return; // Wait for auth and database to be ready
        }

        const currentDocPath = docPath(state.userId);
        const unsubscribeSnapshot = onSnapshot(doc(db, currentDocPath), (docSnapshot) => {
            if (docSnapshot.exists()) {
                const data = docSnapshot.data();
                dispatch({
                    type: 'SET_STATE_FROM_FIRESTORE',
                    payload: data,
                });
            } else {
                // Document doesn't exist yet, save initial state structure
                saveDesign(state.userId, state);
            }
        }, (error) => {
            console.error("Firestore subscription error: ", error);
            dispatch({ type: 'SET_ERROR', payload: `Data sync error: ${error.message}` });
        });

        return () => unsubscribeSnapshot();
    }, [db, state.isAuthReady, state.userId]);


    /**
     * Saves the current relevant design state to Firestore.
     */
    const saveDesign = async (userId, currentState) => {
        if (!db || !userId || userId === 'Anon') return;
        try {
            const stateToSave = {
                yardConfig: currentState.yardConfig,
                currentDesign: currentState.currentDesign,
                catalog: currentState.catalog, // Save catalog for reference
            };
            await setDoc(doc(db, docPath(userId)), stateToSave, { merge: true });
        } catch (e) {
            console.error("Error saving document: ", e);
        }
    };

    // Effect for saving state when design properties change
    // Using a simple throttle logic here to avoid excessive writes
    const saveThrottleRef = useRef(null);
    useEffect(() => {
        if (state.isAuthReady && state.userId && state.userId !== 'Anon') {
            if (saveThrottleRef.current) clearTimeout(saveThrottleRef.current);
            saveThrottleRef.current = setTimeout(() => {
                saveDesign(state.userId, state);
            }, 1000); // Wait 1 second after last change to save
        }
    }, [state.yardConfig, state.currentDesign.plants, state.currentDesign.designSummary, state.isAuthReady, state.userId]);


    // --- Navigation Logic ---
    const goToNextStep = useCallback(() => {
        const currentStepIndex = STEP_KEYS.indexOf(state.designStep);
        if (currentStepIndex < STEP_KEYS.length - 1) {
            dispatch({ type: 'SET_STEP', payload: DESIGN_STEPS[STEP_KEYS[currentStepIndex + 1]] });
        }
    }, [state.designStep]);

    const goToPrevStep = useCallback(() => {
        const currentStepIndex = STEP_KEYS.indexOf(state.designStep);
        if (currentStepIndex > 0) {
            dispatch({ type: 'SET_STEP', payload: DESIGN_STEPS[STEP_KEYS[currentStepIndex - 1]] });
        }
    }, [state.designStep]);


    return (
        <DesignContext.Provider
            value={{
                state,
                dispatch,
                goToNextStep,
                goToPrevStep,
            }}
        >
            {children}
        </DesignContext.Provider>
    );
};

export const useDesign = () => useContext(DesignContext);


// --- 4. DRAG HOOK (src/hooks/usePlantDrag.js) ---

export const usePlantDrag = ({
    plants,
    yardWidth,
    yardHeight,
    dispatch,
    throttleMs = 50,
}) => {
    const cacheRef = useRef(new Map());
    const lastDispatchRef = useRef(0);
    const draggingIdRef = useRef(null);
    // Offset for touch/click point relative to plant center
    const offsetRef = useRef({ x: 0, y: 0 });
    const canvasRef = useRef(null);

    // Sync cache when plants change
    useEffect(() => {
        const map = cacheRef.current;
        // 1. Remove stale entries
        Array.from(map.keys()).forEach(k => {
            if (!plants.find(p => p.id === k)) map.delete(k);
        });
        // 2. Add/Update entries
        plants.forEach(p => {
            // Update placement if it exists, or add new plant
            map.set(p.id, { ...p.placement });
        });
    }, [plants]);

    const startDrag = useCallback((e, plant) => {
        if (!canvasRef.current || !plant.placement) return;
        const rect = canvasRef.current.getBoundingClientRect();

        // Get client coordinates (supports mouse and touch)
        const clientX = e.touches?.[0]?.clientX ?? e.clientX;
        const clientY = e.touches?.[0]?.clientY ?? e.clientY;

        // Calculate plant center position in pixels
        const plantCenterX = (plant.placement.x / yardWidth) * rect.width;
        const plantCenterY = (plant.placement.y / yardHeight) * rect.height;

        draggingIdRef.current = plant.id;
        // Calculate the offset from the plant center to the mouse/touch point
        offsetRef.current = {
            x: clientX - rect.left - plantCenterX,
            y: clientY - rect.top - plantCenterY,
        };
        // Disable text selection/other browser behavior
        e.preventDefault();
        e.stopPropagation();
    }, [yardWidth, yardHeight]);


    const moveDrag = useCallback((e) => {
        const id = draggingIdRef.current;
        if (!id || !canvasRef.current) return;
        e.preventDefault(); // Prevents touch scrolling

        const rect = canvasRef.current.getBoundingClientRect();
        const clientX = e.touches?.[0]?.clientX ?? e.clientX;
        const clientY = e.touches?.[0]?.clientY ?? e.clientY;

        // Calculate new center position in pixels, accounting for initial offset
        const newCenterX = clientX - rect.left - offsetRef.current.x;
        const newCenterY = clientY - rect.top - offsetRef.current.y;

        // Convert pixel position back to garden coordinates (meters)
        let x = (newCenterX / rect.width) * yardWidth;
        let y = (newCenterY / rect.height) * yardHeight;

        // Clamp coordinates to stay within bounds
        x = Math.min(yardWidth, Math.max(0, x));
        y = Math.min(yardHeight, Math.max(0, y));

        const map = cacheRef.current;
        const currentPlacement = map.get(id) || {};
        const updated = { ...currentPlacement, x, y };
        map.set(id, updated);

        // Throttle dispatch to Firestore/Context
        const now = Date.now();
        if (now - lastDispatchRef.current > throttleMs) {
            lastDispatchRef.current = now;
            dispatch({
                type: 'UPDATE_PLANT_PLACEMENT',
                payload: { id, placement: updated },
            });
        }
    }, [yardWidth, yardHeight, dispatch, throttleMs]);

    const endDrag = useCallback(() => {
        const id = draggingIdRef.current;
        if (id) {
            // Ensure final placement is dispatched to context/Firestore
            const finalPlacement = cacheRef.current.get(id);
            if (finalPlacement) {
                dispatch({
                    type: 'UPDATE_PLANT_PLACEMENT',
                    payload: { id, placement: finalPlacement },
                });
            }
        }
        draggingIdRef.current = null;
        offsetRef.current = { x: 0, y: 0 };
    }, [dispatch]);

    // Global listeners for movement continuity outside the canvas
    useEffect(() => {
        if (draggingIdRef.current) {
            // Mouse Listeners
            document.addEventListener('mousemove', moveDrag);
            document.addEventListener('mouseup', endDrag);
            // Touch Listeners (passive: false for touchmove to allow e.preventDefault)
            document.addEventListener('touchmove', moveDrag, { passive: false });
            document.addEventListener('touchend', endDrag);
        }
        return () => {
            document.removeEventListener('mousemove', moveDrag);
            document.removeEventListener('mouseup', endDrag);
            document.removeEventListener('touchmove', moveDrag);
            document.removeEventListener('touchend', endDrag);
        };
    }, [moveDrag, endDrag]);

    return { canvasRef, startDrag, endDrag, cacheRef, draggingIdRef };
};


// --- 5. AI SERVICE MOCK (src/services/aiService.js) ---

export const runAiRefinement = async ({
    userId,
    currentDesign,
    yardConfig,
    catalog,
    dispatch,
}) => {
    dispatch({ type: 'SET_LOADING', payload: true });
    dispatch({ type: 'CLEAR_ERROR' });

    try {
        // --- Gemini API Call Logic (Placeholder) ---
        // For demonstration, we use a mock delay and deterministic placement.
        await new Promise((r) => setTimeout(r, 2000));

        const plantMap = catalog.reduce((m, p) => ({ ...m, [p.commonName]: p }), {});

        // Mocked AI generation based on constraints
        const generated = [
            { commonName: 'Lavender', placement: { x: yardConfig.width * 0.2, y: yardConfig.height * 0.3 } },
            { commonName: 'Rose Bush', placement: { x: yardConfig.width * 0.7, y: yardConfig.height * 0.6 } },
            { commonName: 'Dwarf Maple', placement: { x: yardConfig.width * 0.15, y: yardConfig.height * 0.8 } },
            { commonName: 'Stonecrop', placement: { x: yardConfig.width * 0.5, y: yardConfig.height * 0.1 } },
        ].filter(p => plantMap[p.commonName]).map((p) => {
            const meta = plantMap[p.commonName];
            return {
                id: generatePlantId(),
                catalogId: meta.id,
                ...meta,
                ...p,
                placement: {
                    initialRadius: meta.initialRadius,
                    ...p.placement,
                },
            };
        });

        const response = {
            plants: generated,
            designSummary: `AI Master Plan generated for a ${yardConfig.sunExposure} area with ${yardConfig.soilType} soil. Focused on drought-tolerant layers and ensuring optimal spacing for 20-year maturity.`,
            estimatedCost: 1120.75,
        };

        dispatch({
            type: 'UPDATE_DESIGN',
            payload: {
                ...response,
                aiLog: [
                    ...(currentDesign.aiLog || []),
                    {
                        version: 'refinement_v1.0',
                        timestamp: new Date().toISOString(),
                        output: response,
                        status: 'SUCCESS',
                    },
                ],
            },
        });
    } catch (err) {
        console.error('AI refinement error:', err);
        dispatch({ type: 'SET_ERROR', payload: `AI Generation failed: ${err.message}` });
    } finally {
        dispatch({ type: 'SET_LOADING', payload: false });
    }
};


// --- 6. COMPONENTS (src/components/...) ---

// 6.1 Layout: ProgressTracker (src/components/layout/ProgressTracker.jsx)
const ProgressTracker = ({ currentStep }) => {
    const currentStepIndex = STEP_KEYS.indexOf(Object.keys(DESIGN_STEPS).find(key => DESIGN_STEPS[key] === currentStep));

    return (
        <div className="mb-8 p-4 bg-white rounded-xl shadow-md flex justify-between items-center flex-wrap">
            {Object.values(DESIGN_STEPS).map((step, index) => {
                const isComplete = index < currentStepIndex;
                const isActive = index === currentStepIndex;
                return (
                    <div key={step} className={`flex flex-col items-center flex-1 min-w-[30%] sm:min-w-0 transition-colors duration-300 ${isActive ? 'text-green-600 font-bold' : isComplete ? 'text-green-500' : 'text-gray-400'} ${index > 0 ? 'ml-2' : ''}`}>
                        <div className={`w-10 h-10 rounded-full flex items-center justify-center text-white text-lg ring-2 transition-all ${isActive ? 'bg-green-600 ring-green-400 scale-110' : isComplete ? 'bg-green-400 ring-green-300' : 'bg-gray-300 ring-gray-200'}`}>
                            {index + 1}
                        </div>
                        <span className="text-sm mt-2 text-center">{step.split('. ')[1]}</span>
                    </div>
                );
            })}
        </div>
    );
};

// 6.2 Step: YardInput (src/components/steps/YardInput.jsx)
const YardInput = () => {
    const { state, dispatch, goToNextStep } = useDesign();
    const { yardConfig } = state;

    const handleDimensionChange = (field, value) => {
        dispatch({ type: 'UPDATE_YARD_CONFIG', field, value: parseFloat(value) || 0 });
    };
    const handleConstraintChange = (field, value) => {
        dispatch({ type: 'UPDATE_YARD_CONFIG', field, value });
    };

    const isInputValid = yardConfig.width > 0 && yardConfig.height > 0;

    return (
        <div className="p-6 md:p-8 space-y-8">
            <h2 className="text-2xl font-serif text-green-700">{DESIGN_STEPS.INPUT}</h2>
            <p className="text-gray-600">Establish the physical boundaries and environmental conditions of your garden plot.</p>

            <div className="grid md:grid-cols-2 gap-8">
                {/* Garden Dimensions */}
                <div className="p-5 border border-green-200 rounded-lg bg-green-50 shadow-inner">
                    <h3 className="text-lg font-semibold text-green-800 flex items-center mb-3">
                        <Layout className="w-5 h-5 mr-2" /> Garden Size
                    </h3>
                    <p className="text-sm text-gray-500 mb-4">Input the total area (must be greater than 0).</p>
                    <div className="space-y-4">
                        <label className="block">
                            <span className="text-gray-700 font-medium">Width ({yardConfig.unit})</span>
                            <input
                                type="number"
                                min="1"
                                value={yardConfig.width}
                                onChange={(e) => handleDimensionChange('width', e.target.value)}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-200 focus:ring-opacity-50"
                            />
                        </label>
                        <label className="block">
                            <span className="text-gray-700 font-medium">Height ({yardConfig.unit})</span>
                            <input
                                type="number"
                                min="1"
                                value={yardConfig.height}
                                onChange={(e) => handleDimensionChange('height', e.target.value)}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-200 focus:ring-opacity-50"
                            />
                        </label>
                    </div>
                    <p className="mt-4 text-sm text-green-600 font-medium">
                        Total Area: {yardConfig.width * yardConfig.height} {yardConfig.unit}²
                    </p>
                </div>

                {/* Environmental Factors */}
                <div className="p-5 border border-green-200 rounded-lg bg-green-50 shadow-inner">
                    <h3 className="text-lg font-semibold text-green-800 flex items-center mb-3">
                        <Grid className="w-5 h-5 mr-2" /> Environment
                    </h3>
                    <div className="space-y-4">
                        <label className="block">
                            <span className="text-gray-700 font-medium">Sun Exposure</span>
                            <select
                                value={yardConfig.sunExposure}
                                onChange={(e) => handleConstraintChange('sunExposure', e.target.value)}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-200 focus:ring-opacity-50"
                            >
                                {['Full Sun', 'Partial Sun', 'Full Shade'].map(opt => (
                                    <option key={opt} value={opt}>{opt}</option>
                                ))}
                            </select>
                        </label>
                        <label className="block">
                            <span className="text-gray-700 font-medium">Soil Type</span>
                            <select
                                value={yardConfig.soilType}
                                onChange={(e) => handleConstraintChange('soilType', e.target.value)}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-200 focus:ring-opacity-50"
                            >
                                {['Loam', 'Clay', 'Sand'].map(opt => (
                                    <option key={opt} value={opt}>{opt}</option>
                                ))}
                            </select>
                        </label>
                        <label className="block">
                            <span className="text-gray-700 font-medium">Hardiness Zone</span>
                            <input
                                type="text"
                                value={yardConfig.hardinessZone}
                                onChange={(e) => handleConstraintChange('hardinessZone', e.target.value)}
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-200 focus:ring-opacity-50"
                                placeholder="e.g., 8a or 6b"
                            />
                        </label>
                    </div>
                </div>
            </div>

            <div className="flex justify-end pt-4">
                <button
                    onClick={goToNextStep}
                    disabled={!isInputValid}
                    className="flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-full shadow-lg hover:bg-green-700 transition duration-150 disabled:opacity-50"
                >
                    Proceed to Design <ArrowRight className="w-5 h-5 ml-2" />
                </button>
            </div>
        </div>
    );
};

// 6.3 Step: DesignCanvas (src/components/steps/DesignCanvas.jsx)
const DesignCanvas = () => {
    const { state, dispatch, goToPrevStep, goToNextStep } = useDesign();
    const { yardConfig, catalog, growthYear, currentDesign, isLoading } = state;
    const { plants, designSummary } = currentDesign;

    // Initialize usePlantDrag hook
    const { canvasRef, startDrag, endDrag, cacheRef, draggingIdRef } = usePlantDrag({
        plants: plants,
        yardWidth: yardConfig.width,
        yardHeight: yardConfig.height,
        dispatch: dispatch,
        throttleMs: 100,
    });

    const hasPlants = plants.length > 0;
    const { width, height, unit } = yardConfig;

    // Pre-calculate overlap checks for the current simulation year
    const overlapSummary = useMemo(() => {
        let overlaps = [];
        const overlapMap = new Map();
        for (let i = 0; i < plants.length; i++) {
            for (let j = i + 1; j < plants.length; j++) {
                const p1 = plants[i];
                const p2 = plants[j];
                const overlap = calculateOverlap(p1, p2, growthYear);
                if (overlap > 0.1) { // Significant overlap threshold
                    overlaps.push({ p1Id: p1.id, p2Id: p2.id, overlap });
                    overlapMap.set(p1.id, true);
                    overlapMap.set(p2.id, true);
                }
            }
        }
        return { overlaps, overlapMap };
    }, [plants, growthYear]);

    const handleDropFromCatalog = (e) => {
        e.preventDefault();
        if (!canvasRef.current) return;

        // Mock dragging a plant from the catalog (using a predefined ID for simplicity)
        const mockCatalogPlant = catalog[0];

        const rect = canvasRef.current.getBoundingClientRect();
        const clientX = e.clientX;
        const clientY = e.clientY;

        const relativeX = clientX - rect.left;
        const relativeY = clientY - rect.top;

        // Convert pixel position back to garden coordinates (meters)
        let gardenX = (relativeX / rect.width) * width;
        let gardenY = (relativeY / rect.height) * height;

        // Clamp coordinates
        gardenX = Math.max(0, Math.min(width, gardenX));
        gardenY = Math.max(0, Math.min(height, gardenY));

        const newPlant = {
            ...mockCatalogPlant,
            catalogId: mockCatalogPlant.id,
            id: generatePlantId(),
            placement: {
                x: gardenX,
                y: gardenY,
                initialRadius: mockCatalogPlant.initialRadius,
            }
        };

        // Note: For a real app, you would need to store the currently dragged catalog item ID
        // and fetch its data here. Since we don't have a dragStart in this component for the catalog,
        // we use a mock. The AI refinement replaces manual placement anyway.
        // dispatch({ type: 'ADD_PLANT', payload: newPlant });
        dispatch({ type: 'SET_ERROR', payload: "Manual drag-and-drop from the catalog is disabled. Please use 'Generate Initial Plan' or drag existing plants." });
    };

    // Plant Visual component for the canvas
    const PlantVisual = ({ plant }) => {
        // Use cached placement during drag for smooth UI update
        const placement = cacheRef.current.get(plant.id) || plant.placement;

        const currentRadius = getCurrentRadius(plant, growthYear);
        const matureRadius = plant.matureRadius;

        const isOverlapped = overlapSummary.overlapMap.has(plant.id);

        // Convert coordinates to percentage for responsive CSS positioning
        const leftPercent = (placement.x / width) * 100;
        const topPercent = (placement.y / height) * 100;

        // Scale is relative to the *smaller* dimension (to ensure everything fits)
        const canvasSizeFactor = 100 / Math.max(width, height);

        // Circle diameters in percentage (relative to max(width, height))
        const currentDiameterPct = currentRadius * 2 * canvasSizeFactor * (width > height ? height / width : 1);
        const matureDiameterPct = matureRadius * 2 * canvasSizeFactor * (width > height ? height / width : 1);


        return (
            <div
                className={`absolute group cursor-move touch-manipulation transition-shadow duration-300 ${draggingIdRef.current === plant.id ? 'z-50 shadow-2xl ring-4 ring-green-400' : 'z-10'}`}
                style={{
                    left: `${leftPercent}%`,
                    top: `${topPercent}%`,
                    transform: 'translate(-50%, -50%)',
                }}
                onMouseDown={(e) => startDrag(e, plant)}
                onTouchStart={(e) => startDrag(e, plant)}
            >
                {/* Mature Radius Circle (Outer, translucent) */}
                <div
                    className="absolute rounded-full opacity-20 pointer-events-none transition-all duration-300"
                    style={{
                        width: `${matureDiameterPct}vw`,
                        height: `${matureDiameterPct}vw`,
                        left: '50%',
                        top: '50%',
                        transform: 'translate(-50%, -50%)',
                        backgroundColor: plant.color,
                        // Ensure mature size is calculated correctly based on canvas relative scale
                        '--size-factor': `${canvasSizeFactor}`,
                    }}
                ></div>

                {/* Current Radius Circle (Inner, visible) */}
                <div
                    className={`absolute rounded-full border-2 transition-all duration-300 pointer-events-none ${isOverlapped ? 'border-red-600 bg-red-300 opacity-70 ring-4 ring-red-200' : 'border-green-600 bg-green-300 opacity-80'}`}
                    style={{
                        width: `${currentDiameterPct}vw`,
                        height: `${currentDiameterPct}vw`,
                        left: '50%',
                        top: '50%',
                        transform: 'translate(-50%, -50%)',
                        backgroundColor: plant.color,
                    }}
                >
                    <span className="absolute text-xs text-black font-semibold p-1 bg-white rounded shadow-md whitespace-nowrap opacity-0 group-hover:opacity-100 group-focus-within:opacity-100 transition-opacity" style={{ left: '100%', top: '50%', transform: 'translate(5px, -50%)' }}>
                        {plant.commonName}
                    </span>
                </div>

                {/* Remove Button */}
                <button
                    onClick={() => dispatch({ type: 'REMOVE_PLANT', payload: plant.id })}
                    className="absolute -top-3 -right-3 p-1 bg-white border border-red-500 text-red-500 rounded-full shadow-lg opacity-0 group-hover:opacity-100 group-focus-within:opacity-100 transition-opacity z-20"
                    title="Remove Plant"
                >
                    <Trash2 className="w-4 h-4" />
                </button>
            </div>
        );
    };

    return (
        <div className="grid lg:grid-cols-3 min-h-[700px]">
            <div className="lg:col-span-2 flex flex-col">
                <div className="p-6">
                    <h2 className="text-2xl font-serif text-green-700">{DESIGN_STEPS.LAYOUT}</h2>
                    <p className="text-sm text-gray-600 mt-2">
                        Use the AI to generate an optimal layout, then drag the plants to fine-tune their placement. Use the slider to simulate growth.
                        <strong className="block mt-2 p-2 bg-green-100 rounded">
                            Plants are represented by circles: the inner circle is the current size (Year {growthYear}), and the outer circle is the mature (20-year) size. 
                        </strong>
                        Red outlines indicate significant plant overlap.
                    </p>
                </div>

                {/* --- CANVAS --- */}
                <div className="flex-1 bg-gray-100 border-y p-4 flex items-center justify-center relative min-h-[400px]">
                    <div
                        ref={canvasRef}
                        className="bg-gray-100 border-4 border-gray-400 rounded-xl overflow-hidden shadow-inner w-full cursor-grab"
                        // Ensure aspect ratio is maintained based on yard dimensions
                        style={{
                            width: '90%', // Use 90% of container width
                            paddingBottom: `${(height / width) * 90}%`,
                            position: 'relative',
                            margin: '0 auto',
                            backgroundColor: '#e6ffe6',
                            border: '2px solid #38a169',
                            // Custom property for relative sizing
                            '--yard-width': width,
                            '--yard-height': height,
                        }}
                        onDrop={handleDropFromCatalog}
                        onDragOver={(e) => e.preventDefault()}
                    >
                        <div className="absolute inset-0">
                            {hasPlants ? (
                                plants.map(plant => (
                                    <PlantVisual key={plant.id} plant={plant} />
                                ))
                            ) : (
                                <div className="absolute inset-0 flex flex-col items-center justify-center text-gray-500 p-10">
                                    <Palette className="w-16 h-16 text-green-300 mb-4" />
                                    <p className="text-xl font-medium">Ready for Initial Plan Generation</p>
                                    <p className="text-sm mt-1">
                                        Click the "Generate Initial Plan" button in the sidebar to populate the canvas.
                                    </p>
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {/* --- SIMULATION CONTROLS --- */}
                <div className="p-4 border-t bg-white">
                    <h3 className="text-lg font-semibold text-gray-700 mb-3">Simulation Controls</h3>
                    <label className="block mb-4">
                        <span className="text-gray-700 font-medium block mb-2">Simulate Growth Year: {growthYear} / 20</span>
                        <input
                            type="range"
                            min="1"
                            max="20"
                            step="1"
                            value={growthYear}
                            onChange={(e) => dispatch({ type: 'SET_GROWTH_YEAR', payload: parseInt(e.target.value) })}
                            className="w-full h-2 bg-green-100 rounded-lg appearance-none cursor-pointer range-lg"
                        />
                    </label>

                    <div className={`mt-4 p-3 rounded-lg border ${overlapSummary.overlaps.length > 0 ? 'bg-red-50 border-red-200' : 'bg-green-50 border-green-200'}`}>
                        <h4 className="font-semibold text-gray-800">Overlap Check (Year {growthYear})</h4>
                        {plants.length < 2 ? (
                            <p className="text-sm text-gray-600">Place at least two plants to check for overlap.</p>
                        ) : overlapSummary.overlaps.length > 0 ? (
                            <p className="text-sm text-red-600">
                                <X className="w-4 h-4 inline mr-1" />
                                **Warning:** {overlapSummary.overlaps.length} pairs are overlapping by more than 0.1{unit}. Adjust their placement.
                            </p>
                        ) : (
                            <p className="text-sm text-green-600">
                                <Check className="w-4 h-4 inline mr-1" />
                                No significant overlaps detected at this growth stage.
                            </p>
                        )}
                    </div>
                </div>

                <div className="flex justify-between p-4 border-t">
                    <button
                        onClick={goToPrevStep}
                        className="flex items-center px-4 py-2 bg-gray-200 text-gray-700 font-semibold rounded-full hover:bg-gray-300 transition duration-150"
                    >
                        <ArrowLeft className="w-5 h-5 mr-2" /> Back to Constraints
                    </button>
                    <button
                        onClick={goToNextStep}
                        disabled={!hasPlants}
                        className="flex items-center px-4 py-2 bg-green-600 text-white font-semibold rounded-full shadow-lg hover:bg-green-700 transition duration-150 disabled:opacity-50"
                    >
                        Review Plan <ArrowRight className="w-5 h-5 ml-2" />
                    </button>
                </div>
            </div>

            {/* --- SIDEBAR CONTROLS --- */}
            <div className="lg:col-span-1 border-l bg-white flex flex-col">
                <div className="p-4 border-b">
                    <h3 className="text-lg font-semibold text-gray-700 mb-3">AI Architectural Refinement</h3>
                    <p className="text-sm italic text-gray-600 mb-4 font-mono leading-snug h-16 overflow-hidden">
                        {designSummary}
                    </p>
                    <button
                        onClick={() => runAiRefinement({ userId: state.userId, currentDesign, yardConfig, catalog, dispatch })}
                        disabled={isLoading}
                        className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg transition duration-150 shadow-md disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
                    >
                        {isLoading ? (
                            <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
                        ) : (
                            <Move className="w-5 h-5 mr-2" />
                        )}
                        {hasPlants ? 'Rerun Refinement' : 'Generate Initial Plan'}
                    </button>
                    <p className="text-xs text-gray-500 mt-2">
                        The AI generates optimal spacing based on your goals.
                    </p>
                </div>

                <div className="p-4 border-t">
                    <h3 className="text-lg font-semibold text-gray-700 mb-3">Plant Catalog</h3>
                    <div className="space-y-3 max-h-48 overflow-y-auto pr-2">
                        {catalog.map(plant => (
                            <div
                                key={plant.id}
                                className="p-3 bg-gray-50 border border-gray-200 rounded-lg shadow-sm"
                            >
                                <p className="font-medium text-gray-800 flex items-center">
                                    <div className="w-3 h-3 rounded-full mr-2" style={{ backgroundColor: plant.color }}></div>
                                    {plant.commonName}
                                </p>
                                <p className="text-xs text-gray-500">Mature Radius: {plant.matureRadius} {unit}</p>
                            </div>
                        ))}
                    </div>
                </div>

                <div className="p-4 border-t flex-1 overflow-y-auto">
                    <h3 className="text-lg font-semibold text-gray-700 mb-3">Placed Plants ({plants.length})</h3>
                    <div className="space-y-3 pr-2">
                        {plants.map(plant => {
                            const currentRadius = getCurrentRadius(plant, growthYear);
                            return (
                                <div key={plant.id} className="p-3 bg-white border border-gray-200 rounded-lg flex justify-between items-center shadow-sm">
                                    <div>
                                        <p className="font-medium text-gray-800">{plant.commonName}</p>
                                        <p className="text-xs text-gray-500">
                                            Pos: ({plant.placement.x.toFixed(1)}, {plant.placement.y.toFixed(1)}) {unit}
                                        </p>
                                    </div>
                                    <button
                                        onClick={() => dispatch({ type: 'REMOVE_PLANT', payload: plant.id })}
                                        className="text-red-500 hover:text-red-700 p-1 rounded-full bg-red-100 transition duration-150"
                                        title="Remove Plant"
                                    >
                                        <Trash2 className="w-4 h-4" />
                                    </button>
                                </div>
                            );
                        })}
                    </div>
                </div>
            </div>
        </div>
    );
};

// 6.4 Step: ReviewAndExport (src/components/steps/ReviewAndExport.jsx)
const ReviewAndExport = () => {
    const { state, goToPrevStep } = useDesign();
    const { yardConfig, currentDesign, growthYear } = state;
    const { plants, estimatedCost } = currentDesign;

    // Calculate final overlap summary at year 20
    const finalOverlaps = useMemo(() => {
        let overlaps = [];
        for (let i = 0; i < plants.length; i++) {
            for (let j = i + 1; j < plants.length; j++) {
                const p1 = plants[i];
                const p2 = plants[j];
                const overlap = calculateOverlap(p1, p2, 20); // Check at max maturity
                if (overlap > 0.1) {
                    overlaps.push({
                        p1Name: p1.commonName,
                        p2Name: p2.commonName,
                        overlap: overlap.toFixed(2),
                    });
                }
            }
        }
        return overlaps;
    }, [plants]);

    return (
        <div className="p-6 md:p-8 space-y-8">
            <h2 className="text-2xl font-serif text-green-700">{DESIGN_STEPS.REVIEW}</h2>
            <p className="text-gray-600">Review the final AI-refined design and 20-year simulation results before exporting your plan.</p>

            <div className="grid md:grid-cols-3 gap-6">
                {/* Constraints Summary */}
                <div className="bg-blue-50 p-4 rounded-lg border border-blue-200 shadow-sm">
                    <h3 className="font-bold text-blue-800 mb-2">Garden Environment</h3>
                    <p className="text-sm">Dimensions: {yardConfig.width} x {yardConfig.height} {yardConfig.unit}</p>
                    <p className="text-sm">Sun Exposure: {yardConfig.sunExposure}</p>
                    <p className="text-sm">Soil Type: {yardConfig.soilType}</p>
                    <p className="text-sm">Hardiness Zone: {yardConfig.hardinessZone}</p>
                </div>

                {/* Plant Count Summary */}
                <div className="bg-yellow-50 p-4 rounded-lg border border-yellow-200 shadow-sm">
                    <h3 className="font-bold text-yellow-800 mb-2">Planting Summary</h3>
                    <p className="text-sm">Total Plants Placed: {plants.length}</p>
                    <p className="text-sm">Estimated Total Cost: <span className="font-bold text-xl">${estimatedCost.toFixed(2)}</span></p>
                </div>

                {/* Overlap Status */}
                <div className={`p-4 rounded-lg border shadow-sm ${finalOverlaps.length > 0 ? 'bg-red-50 border-red-200' : 'bg-green-50 border-green-200'}`}>
                    <h3 className="font-bold mb-2 flex items-center">
                        {finalOverlaps.length > 0 ? <X className="w-5 h-5 mr-1 text-red-600" /> : <Check className="w-5 h-5 mr-1 text-green-600" />}
                        Long-Term Spacing (Year 20)
                    </h3>
                    {finalOverlaps.length > 0 ? (
                        <p className="text-sm text-red-700">Warning: {finalOverlaps.length} pairs of plants will overlap significantly at full maturity. Adjust in Step 2.</p>
                    ) : (
                        <p className="text-sm text-green-700">Excellent! No significant plant overlaps are predicted at full maturity.</p>
                    )}
                </div>
            </div>

            {/* AI Summary and Log */}
            <div className="p-5 border border-gray-200 rounded-lg bg-gray-50 shadow-inner">
                <h3 className="text-lg font-semibold text-gray-800 mb-2">AI Design Notes</h3>
                <p className="text-sm italic text-gray-600">{currentDesign.designSummary}</p>
            </div>

            {/* Detailed Placement List */}
            <h3 className="text-xl font-semibold text-gray-700 pt-4">Placement Details</h3>
            <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200 shadow-md rounded-lg">
                    <thead className="bg-gray-50">
                        <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Plant</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Coordinates (X, Y)</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Mature Radius ({yardConfig.unit})</th>
                        </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                        {plants.map(plant => (
                            <tr key={plant.id}>
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{plant.commonName}</td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    ({plant.placement.x.toFixed(2)}, {plant.placement.y.toFixed(2)})
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{plant.matureRadius.toFixed(2)}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>

            <div className="flex justify-between p-4 border-t">
                <button
                    onClick={goToPrevStep}
                    className="flex items-center px-4 py-2 bg-gray-200 text-gray-700 font-semibold rounded-full hover:bg-gray-300 transition duration-150"
                >
                    <ArrowLeft className="w-5 h-5 mr-2" /> Adjust Design
                </button>
                {/* Placeholder for future Export button */}
                <button
                    onClick={() => console.log('Exporting design...')}
                    className="flex items-center px-4 py-2 bg-green-700 text-white font-semibold rounded-full shadow-lg hover:bg-green-800 transition duration-150"
                >
                    Export Final Plan
                </button>
            </div>
        </div>
    );
};


// --- 7. MAIN APPLICATION WRAPPER ---

const Main = () => {
    const { state, dispatch } = useDesign();

    const renderStep = () => {
        switch (state.designStep) {
            case DESIGN_STEPS.INPUT:
                return <YardInput />;
            case DESIGN_STEPS.LAYOUT:
                return <DesignCanvas />;
            case DESIGN_STEPS.REVIEW:
                return <ReviewAndExport />;
            default:
                return <div className="p-8 text-center text-gray-500">Unknown step.</div>;
        }
    };

    return (
        <>
            {/* Tailwind Import */}
            <script src="https://cdn.tailwindcss.com"></script>
            {/* Custom Styles for aesthetics and responsiveness */}
            <style>{`
                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
                .font-inter { font-family: 'Inter', sans-serif; }
                .range-lg::-webkit-slider-thumb {
                    -webkit-appearance: none;
                    appearance: none;
                    width: 20px;
                    height: 20px;
                    border-radius: 50%;
                    background: #10b981;
                    cursor: pointer;
                    box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.3);
                }
                .range-lg::-moz-range-thumb {
                    width: 20px;
                    height: 20px;
                    border-radius: 50%;
                    background: #10b981;
                    cursor: pointer;
                    box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.3);
                }
                /* Visual size correction for the canvas circle sizing in PlantVisual */
                .w-full { width: 100% !important; }
                .h-full { height: 100% !important; }
            `}</style>
            <div className="min-h-screen bg-gray-50 p-4 md:p-8 font-inter">
                <div className="max-w-7xl mx-auto">
                    <h1 className="text-4xl font-extrabold text-green-800 mb-8 text-center font-serif">
                        DreamYard-AI: Landscape Master Planner
                    </h1>

                    <ProgressTracker currentStep={state.designStep} />

                    {/* Global Error Display */}
                    {state.error && (
                        <div role="alert" className="mb-4 p-3 bg-red-100 border-l-4 border-red-500 text-red-700 rounded-md">
                            <p className="font-bold">System Alert:</p>
                            <p>{state.error}</p>
                        </div>
                    )}

                    <div className="bg-white rounded-xl shadow-2xl overflow-hidden border border-gray-100">
                        {/* Using min-h-[700px] ensures consistent height */}
                        <div className="min-h-[700px] flex flex-col">
                            {renderStep()}
                        </div>
                    </div>

                    {/* Developer Status Bar */}
                    <div className="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded-lg text-sm text-yellow-700">
                        <p className="font-semibold">App Status (for Dev/Ops):</p>
                        <p>User ID: <span className="font-mono text-xs">{state.userId || 'Not Ready (Anon)'}</span></p>
                        <p>Auth Ready: {state.isAuthReady ? 'Yes' : 'No'}</p>
                        <p>Total Plants Placed: {state.currentDesign.plants.length}</p>
                    </div>
                </div>
            </div>
        </>
    );
};

// 7. Wires up App.jsx
export default function App() {
    return (
        <DesignProvider>
            <Main />
        </DesignProvider>
    );
}

