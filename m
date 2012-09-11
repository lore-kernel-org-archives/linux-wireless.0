Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52692 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab2IKJmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 05:42:53 -0400
Received: by obbuo13 with SMTP id uo13so421626obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 02:42:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNzdXFbcxNw0M7oYsvidiLnckycy4V73Y+pG4oUNqeCJvQ@mail.gmail.com>
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
Date: Tue, 11 Sep 2012 17:42:52 +0800
Message-ID: <CAEFj984je_UEriLbTmJ0KC9+M-FKOpiithuapMRUHRG3WCZ4hA@mail.gmail.com> (sfid-20120911_114258_200222_8EE1CC41)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>, Adrian Chadd <adrian@freebsd.org>,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Nick

> Have you tried disabing RX or TX only encryption/decryption on hw
> trough PCU DIAG register ?

Nope. Is that same with loading the ath5k with nohwcrypt=1 to do
purely SW encryption/decryption?

----
Chun-Yeow
