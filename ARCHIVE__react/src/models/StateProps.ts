export interface StateProps<T> {
    setState: React.Dispatch<React.SetStateAction<T>>,
    state: T,
}