Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52699 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbYLTWXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 17:23:41 -0500
Message-ID: <494D706B.9090209@lwfinger.net> (sfid-20081220_232349_893507_4B1B1A74)
Date: Sat, 20 Dec 2008 16:23:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: herton@mandriva.com.br, linux-wireless@vger.kernel.org
Subject: Re: false alarm - Re: throughput problem with rtl8187B within last
 few days (again)?
References: <369918.55300.qm@web23107.mail.ird.yahoo.com>
In-Reply-To: <369918.55300.qm@web23107.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> Hi,
> 
> Am really sorry about the false alarm - apparently doing 
> "mke2fs -c -c " on a USB disk on the same hub does very bad things to the throughput of USB wireless device, or rtl8187 specifically. Normal disk usages (copying large files) has no effect at all, so I guess we'll just have to avoid mke2fs or possibly also e2fsck too often :-).

It must do a lot of reads/writes and occupies both USB bandwidth and the USB
queues. I've never even formatted a USB disk. Having more than one hub has
advantages.

Sorry I didn't respond earlier. Gmail decided your first post was spam. It was
the only false positive of about 500 in the Spam list.

Larry
