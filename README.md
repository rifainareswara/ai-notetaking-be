# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:

```js
export default tseslint.config([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      ...tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      ...tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      ...tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default tseslint.config([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```
Deploy k8s

```
cd ~/project/ai-notetaking-be
docker build -t ai-notetaking:v1 .
```

```
docker save ai-notetaking:v1 | sudo k3s ctr images import -
```

```
nano k8s-project.yaml
```

```
# --- 1. DEPLOYMENT (Pengganti service 'backend' di compose) ---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ai-note-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ai-note-be
  template:
    metadata:
      labels:
        app: ai-note-be
    spec:
      containers:
      - name: backend
        image: ai-notetaking:v1   # Nama image yang tadi kita build
        imagePullPolicy: Never    # PENTING: Gunakan image lokal (jangan download dari internet)
        ports:
        - containerPort: 3000     # Port aplikasi Go (internal)
        # resources:              # Opsional: Membatasi penggunaan CPU/RAM
        #   limits:
        #     memory: "512Mi"
        #     cpu: "500m"

---
# --- 2. SERVICE (Pengganti bagian 'ports' di compose) ---
apiVersion: v1
kind: Service
metadata:
  name: ai-note-service
spec:
  type: NodePort
  selector:
    app: ai-note-be
  ports:
    - port: 3000          # Port di cluster k8s
      targetPort: 3000    # Port di aplikasi Go Anda
      nodePort: 30009     # Port akses dari luar (Sesuai keinginan Anda: 3009)
```

```
k apply -f k8s-project.yaml
```

```
k get pods
k get svc
```