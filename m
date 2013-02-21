Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50837 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3BUBIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 20:08:06 -0500
Received: by mail-bk0-f43.google.com with SMTP id jm19so3936234bkc.30
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 17:08:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302210432480.22701@icf.org.ru>
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
	<CAEFj9871wuavGjjs=KRPK0Wq3gxeOxLP_Az6OU7LAJFw+W=6-g@mail.gmail.com>
	<alpine.DEB.2.02.1302202327450.2057@icf.org.ru>
	<alpine.DEB.2.02.1302210432480.22701@icf.org.ru>
Date: Thu, 21 Feb 2013 09:08:04 +0800
Message-ID: <CAEFj9876NOQLNSjHjDGn34PSHi2nE6TJxc0zeMrEsG76c3d_aA@mail.gmail.com> (sfid-20130221_020809_333550_B9E38F0F)
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: devel@lists.open80211s.org, Adrian Chadd <adrian@freebsd.org>,
	ath9k-devel@lists.ath9k.org, Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> hm, but ibss not hit this path too because is_mybeacon is 0 in this mode,
> seems this works only for station mode.

All the mesh nodes will generate its own beacon same as IBSS. Adrian
has mentioned that mode that supports multiple sources of beacons
should be disabled the ANI. Perhaps, someone can comment on this why.

---
Chun-Yeow
