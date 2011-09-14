Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f42.google.com ([209.85.212.42]:56973 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab1INJPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:15:35 -0400
Received: by vwl1 with SMTP id 1so2397507vwl.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:15:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0C9DEF26@SJEXCHCCR02.corp.ad.broadcom.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<CAC9WiBi5L7uV=OzYBKs=sdjRr4Xykcd2USQPtPhCsSBLdpW-6g@mail.gmail.com>
	<20110913132844.GB11772@tuxdriver.com>
	<CACna6ryHL1K-1E7aZz_-5XzQZST5bzM4Fh99HbcmQDXvjn4ooA@mail.gmail.com>
	<400C43189542CE41BC0A5B252FC90136BC0C9DEF26@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Wed, 14 Sep 2011 11:15:34 +0200
Message-ID: <CAC9WiBjGV_SgD6UAY_u8McmQXnz5EFDdtD1O1nWgL6mfQfS1nA@mail.gmail.com> (sfid-20110914_111538_674116_C6E68300)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/14 Arend Van Spriel <arend@broadcom.com>:
>
> Francis has a 4313. As support for that device is not yet in b43 you could consider not claiming it for now in bcma.
>

yes that's right.

That would be true for all cards depending on those broken phy devs:

drivers/net/wireless/b43/Kconfig:config B43_PHY_HT
drivers/net/wireless/b43/Kconfig:       bool "Support for HT-PHY
devices (BROKEN)"
drivers/net/wireless/b43/Kconfig:         Support for the HT-PHY.
drivers/net/wireless/b43/Kconfig:config B43_PHY_LCN
drivers/net/wireless/b43/Kconfig:       bool "Support for LCN-PHY
devices (BROKEN)"
drivers/net/wireless/b43/Kconfig:         Support for the LCN-PHY.


-- 
Francis
