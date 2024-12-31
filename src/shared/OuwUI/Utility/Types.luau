local m = {
    OuwUIType = nil;
}
export type OuwUIType = {
    Cleaner: any?;
    Create: (ClassName: any) -> ();
    Hydrate: (Object: any) -> ();
    Clean: () -> ();
}

return m;