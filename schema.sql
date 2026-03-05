--
-- PostgreSQL database dump
--

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-03-05 13:07:47

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16402)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 16465)
-- Name: budgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budgets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    category_id uuid,
    limit_amount numeric NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.budgets OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16427)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    name character varying(100) NOT NULL,
    type character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT categories_type_check CHECK (((type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying])::text[])))
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16442)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    category_id uuid,
    amount numeric(10,2) NOT NULL,
    type character varying(20),
    description text,
    transaction_date date DEFAULT CURRENT_DATE,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16413)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100),
    email character varying(150) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 4953 (class 0 OID 16465)
-- Dependencies: 223
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.budgets (id, user_id, category_id, limit_amount, created_at) FROM stdin;
5637ddda-7335-4726-9b48-f862b8bf84fa	297b27d2-283f-4904-8b7f-255eb027047e	c76113b7-2b8c-4a84-926f-d1e85134b7b7	1000	2026-03-05 00:21:08.656583
\.


--
-- TOC entry 4951 (class 0 OID 16427)
-- Dependencies: 221
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, user_id, name, type, created_at) FROM stdin;
dfafdef0-b846-483c-a246-e27849be6567	d21fa5c8-49bc-41d6-a2a0-ab2e9005c2ec	Food	expense	2026-03-04 23:21:44.983579
c76113b7-2b8c-4a84-926f-d1e85134b7b7	297b27d2-283f-4904-8b7f-255eb027047e	Food	expense	2026-03-05 00:14:28.951338
\.


--
-- TOC entry 4952 (class 0 OID 16442)
-- Dependencies: 222
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, user_id, category_id, amount, type, description, transaction_date, created_at) FROM stdin;
b60af4cf-9658-4820-902d-b9db5775422f	297b27d2-283f-4904-8b7f-255eb027047e	c76113b7-2b8c-4a84-926f-d1e85134b7b7	350.00	expense	Dinner Updated	2026-03-05	2026-03-05 00:15:34.380459
\.


--
-- TOC entry 4950 (class 0 OID 16413)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password_hash, created_at) FROM stdin;
d21fa5c8-49bc-41d6-a2a0-ab2e9005c2ec	Rajshree	raj@test.com	$2b$10$yEgKiMH.5wxHkZMjamYEw.c/HRrP95EujbPie4/0lCRvzWY8GdRLy	2026-03-04 23:05:12.451625
297b27d2-283f-4904-8b7f-255eb027047e	Test User	testuser@gmail.com	$2b$10$Kai48vkA0DCXAdMitlnWHeHxmCeIXMtqjpcuwg3c17/2goYBUJNgC	2026-03-05 00:12:16.712007
\.


--
-- TOC entry 4797 (class 2606 OID 16475)
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- TOC entry 4793 (class 2606 OID 16436)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 16454)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 16426)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4791 (class 2606 OID 16424)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4801 (class 2606 OID 16481)
-- Name: budgets budgets_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 4802 (class 2606 OID 16476)
-- Name: budgets budgets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4798 (class 2606 OID 16437)
-- Name: categories categories_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4799 (class 2606 OID 16460)
-- Name: transactions transactions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- TOC entry 4800 (class 2606 OID 16455)
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-03-05 13:07:47

--
-- PostgreSQL database dump complete
--
