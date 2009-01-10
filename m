Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53139 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZAJDPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 22:15:48 -0500
Date: Fri, 9 Jan 2009 22:12:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Erik Ekman <erik@kryo.se>, linux-wireless@vger.kernel.org,
	trivial@kernel.org
Subject: Re: [PATCH 2.6.28] Wireless: Fix Kconfig fact error
Message-ID: <20090110031203.GA22370@tuxdriver.com> (sfid-20090110_041628_924243_650E44C5)
References: <20081230224928.c0558274.erik@kryo.se> <alpine.LNX.1.10.0901100107040.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.1.10.0901100107040.5377@jikos.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 10, 2009 at 01:07:58AM +0100, Jiri Kosina wrote:
> On Tue, 30 Dec 2008, Erik Ekman wrote:
> 
> > Raytheon cards use 2.4 GHz, not 2.4 MHz.
> > See http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Linux.Wireless.drivers.html#Raylink
> > 
> > Signed-off-by: Erik Ekman <erik@kryo.se>
> 
> As this doesn't seem to be picked up to now by subsystem tree, I have 
> queued it in the trivial tree. Thanks Erik.

Actually, I have it.  Please drop it from your tree.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
