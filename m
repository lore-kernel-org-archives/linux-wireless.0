Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39877 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbaDLKMw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2014 06:12:52 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Pratik Prajapati <pratik.prajapati.linux@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ramping up on wifi linux.
References: <CAK75eTrMB_BD6-mUYw5x8MEaXp+w2n1VDq4cBy8FSvFjuDLebA@mail.gmail.com>
Date: Sat, 12 Apr 2014 13:12:51 +0300
In-Reply-To: <CAK75eTrMB_BD6-mUYw5x8MEaXp+w2n1VDq4cBy8FSvFjuDLebA@mail.gmail.com>
	(Pratik Prajapati's message of "Fri, 11 Apr 2014 17:01:07 -0700")
Message-ID: <87y4zahn4s.fsf@purkki.adurom.net> (sfid-20140412_121256_430120_D6452E41)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pratik Prajapati <pratik.prajapati.linux@gmail.com> writes:

> I am very new to linux wirelss/wifi stuff. I want to start learning
> wifi linux stack and technology.
>
> I would really appreciate if somebody please explain me from where to
> start. Yeah, wiki pages are best to start, i am going through 802.11
> relates wiki pages but how about learning software stack?

mac80211_hwsim is a good place to start. A simple driver and you can run
all sorts of tests over the simulated radio interface, including
sniffers.

-- 
Kalle Valo
