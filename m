Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35865 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2IIBzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2012 21:55:01 -0400
Received: by obbuo13 with SMTP id uo13so1272312obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2012 18:55:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj986i9XUcEN0i2y5=YLh2RX8MZOf+60i8XL4jMiq5-JcJ6Q@mail.gmail.com>
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
Date: Sat, 8 Sep 2012 18:47:39 -0700
Message-ID: <CAJ-Vmonesc=VPMUJgS1GHTUS-Xj_BTohv0rQ9ZS+rW-761g_8w@mail.gmail.com> (sfid-20120909_035557_361451_D91B1FBD)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Adrian Chadd <adrian@freebsd.org>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,

Yeoh - can you please email me privately with a summary of what you
implemented, what you've tested and what worked / what didn't work?

I can do some digging into what changed with the encryption stuff and
see if I can figure it out in my (limited) spare time. I can try to do
it sometime next week.

I've been meaning to do MFP for FreeBSD's ath/net80211 driver so I
guess now it's a fine time to dig into the older chipset code and
figure out what's going on.

Thanks,


Adrian
