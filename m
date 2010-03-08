Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alcalazamora.dti2.net ([81.24.162.8]:2161 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0CHMv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 07:51:26 -0500
Received: from [172.16.16.6] ([81.24.161.20])
	(authenticated user jorge@dti2.net)
	by alcalazamora.dti2.net (alcalazamora.dti2.net [81.24.162.8])
	(MDaemon PRO v10.1.2)
	with ESMTP id md50007883496.msg
	for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 13:45:57 +0100
Message-ID: <4B94F183.2080002@dti2.net>
Date: Mon, 08 Mar 2010 13:45:55 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
MIME-Version: 1.0
To: br1@einfach.org
CC: me@bobcopeland.com, linville@tuxdriver.com, 8an@praha12.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, benoit.papillault@free.fr
Subject: Re: [PATCH v2] ath5k: fix I/Q calibration (for real)
References: <20100308025841.7460.69949.stgit@void>
In-Reply-To: <20100308025841.7460.69949.stgit@void>
Content-Type: text/plain; charset=UTF-8
Reply-To: jorge@dti2.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 08/03/2010 3:59, Bruno Randolf escribió:
> 
> 4.) we can't use ENABLE_BITS when we want to write a number (the number can
> contain zeros). also always write the correction values first and set ENABLE
> bit last, like the HAL does.
> 
	Hi Bruno,

	does not ath5k_hw_commit_eeprom_settings() have the same problem described
above when committing the IQ values from the EEPROM? legacy-hal does differently
too.

-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================

