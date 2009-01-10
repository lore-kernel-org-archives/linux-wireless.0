Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46353 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753793AbZAJAH7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 19:07:59 -0500
Date: Sat, 10 Jan 2009 01:07:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Erik Ekman <erik@kryo.se>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	trivial@kernel.org
Subject: Re: [PATCH 2.6.28] Wireless: Fix Kconfig fact error
In-Reply-To: <20081230224928.c0558274.erik@kryo.se>
Message-ID: <alpine.LNX.1.10.0901100107040.5377@jikos.suse.cz> (sfid-20090110_010803_701320_E19DACC2)
References: <20081230224928.c0558274.erik@kryo.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 30 Dec 2008, Erik Ekman wrote:

> Raytheon cards use 2.4 GHz, not 2.4 MHz.
> See http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Linux.Wireless.drivers.html#Raylink
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>

As this doesn't seem to be picked up to now by subsystem tree, I have 
queued it in the trivial tree. Thanks Erik.

-- 
Jiri Kosina
SUSE Labs
