import { StateProps } from '../models/StateProps'

const RadioButton: React.FC<{selectedState: StateProps<number>, id: number}> = ({children, selectedState, id}) => {
    const activeStyles = selectedState.state !== id ? 
    'text-gray-800 border-gray-200' :
    'bg-gray-700 border-gray-700 text-white'
    return <button 
        className={`flex-1 border-2 py-4 px-8 rounded-2xl text-4xl font-semibold transition-colors ${activeStyles}`}
        onClick={() => selectedState.setState(id)}
    >{children}</button>
}

export default RadioButton;