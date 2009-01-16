Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39907 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZAPSpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 13:45:44 -0500
Date: Fri, 16 Jan 2009 13:38:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: garbaged AP mac address in dmesg in wireless-testing?
Message-ID: <20090116183826.GC10037@tuxdriver.com> (sfid-20090116_194549_991253_7CF6D553)
References: <3ace41890901160907w2d04da91r61744477ac64e018@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3ace41890901160907w2d04da91r61744477ac64e018@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 05:07:50PM +0000, Hin-Tak Leung wrote:
> Since a few days ago, my dmesg is looking like this - instead of the
> older AA:BB:CC:DD:EE:FF form
> with the mac address of the AP.
> That ffff88* looks like a pointer/address to me? Is this change intentional?
> 
> --------------
> wlan2 direct probe responded
> wlan2: authenticate with AP ffff880070995aa0
> wlan2: authenticated
> wlan2: associate with AP ffff880070995aa0
> wlan2: RX ReassocResp from ffff88001431f01a (capab=0x431 status=0 aid=1)
> wlan2: associated

Odd...some problem with the "%pM" printk conversion?  What kernel
are you running?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
