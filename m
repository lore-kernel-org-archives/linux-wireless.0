Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53491 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753064AbZAJNof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 08:44:35 -0500
Date: Sat, 10 Jan 2009 14:44:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
cc: Erik Ekman <erik@kryo.se>, linux-wireless@vger.kernel.org,
	trivial@kernel.org
Subject: Re: [PATCH 2.6.28] Wireless: Fix Kconfig fact error
In-Reply-To: <20090110031203.GA22370@tuxdriver.com>
Message-ID: <alpine.LNX.1.10.0901101443460.5377@jikos.suse.cz> (sfid-20090110_144442_227671_56EFD962)
References: <20081230224928.c0558274.erik@kryo.se> <alpine.LNX.1.10.0901100107040.5377@jikos.suse.cz> <20090110031203.GA22370@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Jan 2009, John W. Linville wrote:

> > > Raytheon cards use 2.4 GHz, not 2.4 MHz.
> > > See http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Linux.Wireless.drivers.html#Raylink
> > > Signed-off-by: Erik Ekman <erik@kryo.se>
> > As this doesn't seem to be picked up to now by subsystem tree, I have 
> > queued it in the trivial tree. Thanks Erik.
> Actually, I have it.  Please drop it from your tree.

Ah, right, I looked into wrong repo. Dropped.

-- 
Jiri Kosina
SUSE Labs
