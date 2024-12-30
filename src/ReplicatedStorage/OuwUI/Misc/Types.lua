-- Types.lua
export type InstanceProperties = {
	-- BasePart Properties
	DisplayOrder: number;
	FontFace: Font.new;
	ScrollBarThickness: number;
	TextSize: number;
	Cache: {};
	CanvasSize: UDim2;
	HorizontalAlignment: Enum.HorizontalAlignment;
	VerticalAlignment: Enum.VerticalAlignment;
	FillDirection: Enum.FillDirection;
	TextTransparency: number;
	ClipsDescendants: boolean;
	SortOrder: Enum.SortOrder;
	AspectRatio: number;
	Name: string;
	Parent: Instance;
	Anchored: boolean?,
	BrickColor: BrickColor?,
	CanCollide: boolean?,
	CastShadow: boolean?,
	Color: Color3?,
	Material: Enum.Material?,
	Reflectance: number?,
	Transparency: number?,
	Thickness: number;
	Shape: Enum.PartType?, -- Specific to parts like Part, Ball, Cylinder

	-- BasePart Events
	Touched: (otherPart: BasePart) -> (), -- Triggered when something touches the part
	TouchEnded: (otherPart: BasePart) -> (), -- Triggered when something stops touching the part
	OnClean: () -> (), -- replaces clean function
	NoCleaner: boolean; -- Makes it so this isnot aded to the janitor
	-- Generic Instance Properties
	Archivable: boolean?,

	-- Generic Instance Events
	Destroying: () -> (), -- Triggered before the instance is destroyed
	AncestryChanged: (child: Instance, parent: Instance?) -> (), -- Triggered when the instance's parent changes
	Changed: (property: string) -> (), -- Triggered when a property of the instance changes
	AttributeChanged: (attribute: string) -> (), -- Triggered when an attribute changes

	-- Model Properties
	PrimaryPart: BasePart?,
	WorldPivot: CFrame?,

	-- Camera Properties
	CameraType: Enum.CameraType?,
	CFrame: CFrame?,
	FieldOfView: number?,
	Focus: CFrame?,
	
	TextXAlignment: Enum.TextXAlignment;
	TextYAlignment: Enum.TextYAlignment;
	-- UI Element Properties (TextLabel, TextButton, ImageLabel, ImageButton, etc.)
	Text: string?,
	TextColor3: Color3?,
	Font: Enum.Font?,
	TextScaled: boolean?,
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,
	BorderColor3: Color3?,
	BorderSizePixel: number?,
	Size: UDim2? | Vector3?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	Visible: boolean?,
	Image: string?, -- For ImageLabel and ImageButton
	ImageColor3: Color3?,
	ImageTransparency: number?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	AutoButtonColor: boolean?, -- For TextButton and ImageButton

	-- UI Events (TextLabel, TextButton, ImageLabel, ImageButton, etc.)
	MouseEnter: () -> (), -- Triggered when the mouse enters the UI element
	MouseLeave: () -> (), -- Triggered when the mouse leaves the UI element
	MouseMoved: (x: number, y: number) -> (), -- Triggered when the mouse moves over the element
	MouseWheelForward: () -> (), -- Triggered when the mouse wheel scrolls forward
	MouseWheelBackward: () -> (), -- Triggered when the mouse wheel scrolls backward
	InputBegan: (input: InputObject) -> (), -- Triggered when an input begins (e.g., key press)
	InputEnded: (input: InputObject) -> (), -- Triggered when an input ends (e.g., key release)
	InputChanged: (input: InputObject) -> (), -- Triggered when an input changes (e.g., mouse move)
	MouseButton1Click: () -> (), -- Triggered when the left mouse button is clicked
	MouseButton2Click: () -> (), -- Triggered when the right mouse button is clicked
	MouseButton1Down: () -> (), -- Triggered when the left mouse button is pressed down
	MouseButton1Up: () -> (), -- Triggered when the left mouse button is released
	MouseButton2Down: () -> (), -- Triggered when the right mouse button is pressed down
	MouseButton2Up: () -> (), -- Triggered when the right mouse button is released

	-- BillboardGui Properties
	Adornee: Instance?,
	StudsOffset: Vector3?,
	MaxDistance: number?,
	ExtentsOffset: Vector3?,
	AlwaysOnTop: boolean?,
	
	-- UICorner
	CornerRadius: UDim;
	
	-- BillboardGui Events
	AdorneeChanged: (adornee: Instance?) -> (), -- Triggered when the Adornee property changes

	-- Tool Properties
	RequiresHandle: boolean?,
	Grip: CFrame?,
	Enabled: boolean?,

	-- Tool Events
	Activated: () -> (), -- Triggered when the tool is activated
	Deactivated: () -> (), -- Triggered when the tool is deactivated
	Equipped: (mouse: Mouse) -> (), -- Triggered when the tool is equipped
	Unequipped: () -> (), -- Triggered when the tool is unequipped

	-- Sound Properties
	SoundId: string?,
	Volume: number?,
	PlaybackSpeed: number?,
	TimePosition: number?,
	Looping: boolean?,
	Playing: boolean?,
	RollOffMode: Enum.RollOffMode?,
	MinDistance: number?,

	-- Sound Events
	Played: () -> (), -- Triggered when the sound starts playing
	Stopped: () -> (), -- Triggered when the sound stops
	Ended: () -> (), -- Triggered when the sound finishes playing
	Looped: () -> (), -- Triggered when the sound loops

	-- Animation Properties
	AnimationId: string?,

	-- Animation Events
	KeyframeReached: (keyframeName: string) -> (), -- Triggered when a specific keyframe is reached
}


export type SpringInfoType = {
	Time: number;
	Frequency: number;
	Damping: number;
	Repeat: number;
	RepeatAmount : boolean;
	DelayTime: number;
}
export type TweenInfoType = {
	Time: number;
	EasingStyle: Enum.EasingStyle;
	EasingDirection: Enum.EasingDirection;
	RepeatAmount: number;
	Reverse : boolean;
	DelayTime: number;
}

export type ScopeType = {
	Create: (Name: string) -> ((Properties: InstanceProperties) ->()),
	Hydrate: (Instance: Instance, Properties: InstanceProperties) -> (),
	Extend: () -> ScopeType,
	Value: (...any) -> {Default: any, Changed: RBXScriptSignal,SkipToDefault: (self) -> (),NewAdded: () -> any,NewRemoved: () -> any ,AddWithIndex: (self, index: any, value:any) -> ()},
	SpringInfo: (Time: number,Frequency: number,Damping: number,RepeatAmount: number,Reverse:boolean,DelayTime: number) -> any,
	TweenInfo: (Time: number,EasingStyle: string,EasingDirection: string,RepeatAmount: number,Reverse:boolean,DelayTime: number) -> any,
	Spring: (Value: any, SpringInfo: SpringInfo, Indexes: {}) -> any,
	Tween: (Value: any, TweenInfo: TweenInfoType, Indexes: {}) -> any,
	Add: (...any) -> (),
	Remove: (...any) -> (),
	Clean: (self) -> (),
	Compute: ((Use: any) -> any) -> (),
	Connect: (...any) -> (),
	ForPairs: (Table: {}, (Index: any, Value: any) -> ()) -> (),
}
return nil;