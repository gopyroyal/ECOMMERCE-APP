import React, { useEffect, useState } from "react";

const API = import.meta.env.VITE_API_URL || "/api";

export default function App(){
  const [status, setStatus] = useState("CHECKING…");
  const [products, setProducts] = useState([]);
  const [err, setErr] = useState("");

  useEffect(() => {
    fetch(API + "/health").then(r => r.json()).then(d => setStatus(d.status || "DOWN")).catch(() => setStatus("DOWN"));
    fetch(API + "/products").then(r => r.json()).then(setProducts).catch(e => setErr(String(e)));
  }, []);

  return (
    <>
      <div className="health">
        Backend Health: <span className={status === "OK" ? "ok" : "down"}>{status}</span>
      </div>
      <div id="grid" className="grid">
        {products.length === 0 ? <div className="card">No products yet.</div> :
          products.map(p => (
            <div key={p.id} className="card">
              <img src={p.image_url} alt="" />
              <div className="name">{p.name}</div>
              <div className="desc">{p.description}</div>
              <div className="price">${Number(p.price).toFixed(2)}</div>
            </div>
          ))
        }
      </div>
      {err && <footer id="err">Failed to load products: {err}</footer>}
    </>
  );
}
