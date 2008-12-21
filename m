Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23107.mail.ird.yahoo.com ([217.146.189.47]:27102 "HELO
	web23107.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751595AbYLUBSZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 20:18:25 -0500
Date: Sun, 21 Dec 2008 01:18:23 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: false alarm - Re: throughput problem with rtl8187B within last few days (again)?
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: herton@mandriva.com.br, linux-wireless@vger.kernel.org
In-Reply-To: <494D706B.9090209@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <56034.77798.qm@web23107.mail.ird.yahoo.com> (sfid-20081221_021829_516077_D85D8D37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Sat, 20/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hin-Tak Leung wrote:
> > Hi,
> > 
> > Am really sorry about the false alarm - apparently
> doing 
> > "mke2fs -c -c " on a USB disk on the same
> hub does very bad things to the throughput of USB wireless
> device, or rtl8187 specifically. Normal disk usages (copying
> large files) has no effect at all, so I guess we'll just
> have to avoid mke2fs or possibly also e2fsck too often :-).
> 
> It must do a lot of reads/writes and occupies both USB
> bandwidth and the USB
> queues. I've never even formatted a USB disk. Having
> more than one hub has
> advantages.

Yes, must be; However, it is interesting that normal usage (copying files between two partitions on the new disk) does not interfere with the wireless driver, compared to doing mke2fs/badblock/e2fsck .

My rtl8187B is an integrated part of a (toshiba) laptop - interesting enough lsusb shows 6 buses (one USB 2.0 root hub and 5 USB 1.1 root hubs),
but all 4 external USB sockets are wired up to the that one USB 2.0 root hub for which the internal rtl8187B is also on. 

> Sorry I didn't respond earlier. Gmail decided your
> first post was spam. It was
> the only false positive of about 500 in the Spam list.

Maybe because it was coming from *@sourceforge.net . 



      
