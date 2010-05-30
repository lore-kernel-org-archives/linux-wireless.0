Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxl.seznam.cz ([77.75.76.44]:37670 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab0E3WeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 May 2010 18:34:24 -0400
Cc: =?us-ascii?Q?Pekka=20Pietikainen?= <pp@ee.oulu.fi>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20100528124258.GA27491@ee.oulu.fi>
Date: Mon, 31 May 2010 00:20:30 +0200 (CEST)
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20wireless=2Dregdb=3A=20FI=2FCZ=20updates?=
Mime-Version: 1.0
Message-Id: <25058.24619.30500-29157-1485433759-1275258029@seznam.cz>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've helped with the regulatory rules for CZ, and I thought we should use lower power limits for 5.25 & 5.47 GHz,  because we cannot assure TPC is enabled or not.
Apparently it should be fine to use this higher limit ( 200 mW / 1000 mW ).
Carlos
 
PS: This was discussed here in linux-wireless in december 2008, and Michael Green wrote:

> The tx power levels are worth discussing more. Even though the European
> countries are harmonized on EN301 893 which enforces 200mW EIRP in 5.15-5.35 and
> 1W EIRP in 5.470-5.725, vendors must not blindly set new hardware to transmit at
> these upper limits.
> 
> Each board design must undergo conformance testing to the applicable RF
> conformance spec (in this case 301 893) at which time the vendor will discover
> that various other tests in the conformance spec will limit the achievable
> compliant tx power for that design and it's associated antennas (i.e. power
> spectral density, spurious emissions, etc. So using 200mW and 1W EIRP in code
> may be fine as an upper limit, fail safe, users of the code / hardware
> developers must be educated to ensure awareness that there is no universal
> "compliant tx power" that you can assign for a country that applies to all the
> different hardware out there.
> 
> Michael Green
> Atheros Communications, Inc.
> mgreen@atheros.com
