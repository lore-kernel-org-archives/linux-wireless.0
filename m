Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1495 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbZAVRcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 12:32:35 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 2/6] ath5k: set up rf_banks array at attach time
Date: Thu, 22 Jan 2009 12:32:23 -0500
Message-Id: <20090122172911.M57854@bobcopeland.com> (sfid-20090122_183239_675427_8814FB00)
In-Reply-To: <40f31dec0901220921seb222efw35e35281a5d4a583@mail.gmail.com>
References: <1232631861-6028-3-git-send-email-me@bobcopeland.com> <40f31dec0901220921seb222efw35e35281a5d4a583@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Jan 2009 19:21:18 +0200, Nick Kossifidis wrote
> 2009/1/22 Bob Copeland <me@bobcopeland.com>:
> > ah_rf_banks was being created lazily the first time we did a reset,
> > and the function pointer was also determined every time we reloaded the
> > registers.  
> I've updated phy.c etc on my local tree (check out
> http://www.linuxwireless.org/en/users/Drivers/ath5k#ath5kTODO) and
> i've already fixed that (also fixed the whole rf buffer thing). Please
> give me some time to test it and i'll submit the patches.

Ok, great :)  This patch can be dropped then.

-- 
Bob Copeland %% www.bobcopeland.com

