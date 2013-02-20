Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:42033 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab3BTDau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 22:30:50 -0500
Received: by mail-bk0-f48.google.com with SMTP id jf20so3413916bkc.35
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 19:30:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302200027120.19533@icf.org.ru>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
	<CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
	<alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
	<CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
	<20771.50338.434076.484711@gargle.gargle.HOWL>
	<CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
	<20771.51233.248133.141840@gargle.gargle.HOWL>
	<alpine.DEB.2.02.1302192258510.19584@icf.org.ru>
	<CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
	<alpine.DEB.2.02.1302200027120.19533@icf.org.ru>
Date: Wed, 20 Feb 2013 11:30:48 +0800
Message-ID: <CAEFj9871wuavGjjs=KRPK0Wq3gxeOxLP_Az6OU7LAJFw+W=6-g@mail.gmail.com> (sfid-20130220_043056_249015_8E82ED1E)
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: devel@lists.open80211s.org
Cc: Adrian Chadd <adrian@freebsd.org>, ath9k-devel@lists.ath9k.org,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> but, there is some funny rssi processing sometimes:
>
>
>         /* Update Beacon RSSI, this is used by ANI. */
>         ah->stats.avgbrssi = rssi;
>
> may be i don't understand something, but looks strange.

If I am not mistaken, mesh node (802.11s) does not process beacon RSSI in ath9k,

---
Chun-Yeow
