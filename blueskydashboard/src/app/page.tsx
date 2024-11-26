'use client';

import Image from "next/image";

import { useEffect, useState } from 'react';
import styles from './Landing.module.css'; // Assuming you have CSS modules set up

export default function Home() {

  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
  }, []);

  return (
    <main className={`${styles.main} ${isMounted ? styles.fadeIn : ''}`}>
      <div className={styles.hero}>
        <div className={styles.overlay}>
          <h1 className={styles.title}>Welcome to BlueSky</h1>
          <p className={styles.subtitle}>Empowering your data-driven future</p>
          <button className={styles.ctaButton}>Get Started</button>
        </div>
      </div>
    </main>
  );
}
