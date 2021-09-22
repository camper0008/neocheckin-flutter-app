import { useState } from 'react';
import RadioButton from './components/RadioButton'
import placeholderImage from './images/placeholder.jpg'

const App = () => {
  const [radioSelected, selectRadio] = useState<number>(0);

  return (
    <main className="bg-gradient-to-br from-red-400 to-purple-400 h-screen">
      <div className="
        w-3/4 h-3/4 
        fixed top-1/2 left-1/2 
        transform -translate-y-1/2 -translate-x-1/2 
        bg-white rounded-xl shadow-lg
        flex flex-col justify-evenly items-center
        px-48"
      >
        <div className="relative flex items-center">
            <img className="border border-gray-400" src={placeholderImage} width={240} height={320} alt="Elevbillede"/>
        </div>
        <div className="flex gap-4">
          <RadioButton id={0} selectedState={{state: radioSelected, setState: selectRadio}}>Normal</RadioButton>
          <RadioButton id={1} selectedState={{state: radioSelected, setState: selectRadio}}>Gåtur</RadioButton>
          <RadioButton id={2} selectedState={{state: radioSelected, setState: selectRadio}}>Aftalt</RadioButton>
        </div>
      </div>
    </main>
  );
}

export default App;
