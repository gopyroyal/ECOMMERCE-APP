import React, { useEffect, useState } from 'react'
import { createRoot } from 'react-dom/client'

function App() {
  const [products, setProducts] = useState([]);
  const [health, setHealth] = useState('...');

  useEffect(() => {
    // Backend ALB URL will be set via ENV at build/deploy time (CodeBuild replaces placeholder)
    const api = import.meta.env.VITE_API_URL || 'http://localhost:3000';
    fetch(`${api}/health`).then(r => r.json()).then(d => setHealth(d.status)).catch(()=>setHealth('DOWN'));
    fetch(`${api}/products`).then(r => r.json()).then(setProducts).catch(()=>{});
  }, []);

  return (
    <div style={{fontFamily:'Inter, system-ui', maxWidth: 960, margin: '40px auto'}}>
      <h1>E-Commerce — Gopi</h1>
      <p>Backend Health: <b>{health}</b></p>
      <h2>Products</h2>
      <div style={{display:'grid', gridTemplateColumns:'repeat(3, 1fr)', gap: 16}}>
        {products.map(p => (
          <div key={p.id} style={{border:'1px solid #ddd', borderRadius:12, padding:16}}>
            <img src={p.image_url} alt={p.name} style={{width:'100%', height:160, objectFit:'cover', borderRadius:8}}/>
            <h3>{p.name}</h3>
            <p style={{minHeight:48}}>{p.description}</p>
            <p><b>₹ {Number(p.price).toFixed(2)}</b></p>
          </div>
        ))}
      </div>
    </div>
  )
}

createRoot(document.getElementById('root')).render(<App/>)
