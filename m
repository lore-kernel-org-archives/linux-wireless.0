Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45828 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab2IKQai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 12:30:38 -0400
Received: by pbbrr13 with SMTP id rr13so1023188pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 09:30:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj986+K6TGpR2MXteAY86vAX8D=xVrFWMAVdc9zSuiix+Ogw@mail.gmail.com>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
	<CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	<CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	<1346758521.3737.28.camel@jlt4.sipsolutions.net>
	<CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	<20120905071653.GB3629@w1.fi>
	<CAEFj985iHQJTAqXBkz56BDPodHb9q0Z=x3S5Q43UwA5vU-mfMw@mail.gmail.com>
	<20120905080336.GA4747@w1.fi>
	<CAEFj986i9XUcEN0i2y5=YLh2RX8MZOf+60i8XL4jMiq5-JcJ6Q@mail.gmail.com>
	<CAJ-Vmonesc=VPMUJgS1GHTUS-Xj_BTohv0rQ9ZS+rW-761g_8w@mail.gmail.com>
	<87zk4y3tsz.fsf@purkki.adurom.net>
	<CAEFj9845-oLbFK7_i5hL6bWMF4=oTJ4avDkEv3kpJGXCpaiSiQ@mail.gmail.com>
	<CAFtRNNzdXFbcxNw0M7oYsvidiLnckycy4V73Y+pG4oUNqeCJvQ@mail.gmail.com>
	<CAEFj984je_UEriLbTmJ0KC9+M-FKOpiithuapMRUHRG3WCZ4hA@mail.gmail.com>
	<CAFtRNNyNVnkfyjDGvuUJfYq3pKfiwG+YOpxo0DX_uw6CKiErTA@mail.gmail.com>
	<CAEFj987sqS7ZONEJ0xbsmWjkMijNAr8PnmVpw0ok60rdgS6FpA@mail.gmail.com>
	<CAFtRNNzbizOVOr+J=Z0=JmRCunMwo4Ys_AYaFY7z-xnUE2Tp6w@mail.gmail.com>
	<CAFtRNNy4UWzz7tdnWGSQ++qqx-LGVGZQ=Vae2SO59CB5K2b2+Q@mail.gmail.com>
	<CAEFj986+K6TGpR2MXteAY86vAX8D=xVrFWMAVdc9zSuiix+Ogw@mail.gmail.com>
Date: Tue, 11 Sep 2012 09:30:38 -0700
Message-ID: <CAJ-VmonhhFT91-c6c-5GHF1cHaSqBn_UdMSU7rCBDNMf2iCMXA@mail.gmail.com> (sfid-20120911_183043_837154_AC86F8B1)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Adrian Chadd <adrian@freebsd.org>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Kalle Valo <kvalo@adurom.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is why I asked for a bit of a summary.

What specific behaviour are you chasing from the keycache,
source/destination MAC address matching and encryption engine?

There've apparently been some keycache matching bugs in the past ..



Adrian
