-- CreateEnum
CREATE TYPE "EnumTransitOptionAccessibilities" AS ENUM ('ELEVATOR', 'STAIRS', 'ESCALATOR', 'TOILET', 'WAITING_ROOM', 'BIKE_PARKING', 'RAMP', 'WHEELCHAIR_FRIENDLY', 'DISABLED_TOILET', 'TICKET_PURCHASE', 'ASSISTANCE');

-- CreateEnum
CREATE TYPE "EnumTransitOptionTransportTypes" AS ENUM ('BUS', 'TRAM', 'TRAIN', 'FERRY', 'METRO');

-- CreateTable
CREATE TABLE "User" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "firstName" TEXT,
    "id" TEXT NOT NULL,
    "lastName" TEXT,
    "password" TEXT NOT NULL,
    "roles" JSONB NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "username" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransitOption" (
    "accessibilities" "EnumTransitOptionAccessibilities"[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" TEXT NOT NULL,
    "name" TEXT,
    "transportTypes" "EnumTransitOptionTransportTypes"[],
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TransitOption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransportMap" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "icon" TEXT,
    "id" TEXT NOT NULL,
    "name" TEXT,
    "thumbnailUrl" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "url" TEXT,

    CONSTRAINT "TransportMap_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");
