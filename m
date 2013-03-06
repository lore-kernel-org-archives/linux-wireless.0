Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38782 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab3CFODV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 09:03:21 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Nick Thomas <nhomas@gmail.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k] Recent driver versions break compatibility with AR9285 for me
References: <CAEk6VBHnWn_KF0TJ_vojuOhWFhR6TncAok+B9mqgGzAdC5DzVg@mail.gmail.com>
	<20790.56369.998911.884240@gargle.gargle.HOWL>
	<CAEk6VBHTWn8CX7SKNVQz+T+Wqwe9Na=32Lz=+xOdqncNZFhhkQ@mail.gmail.com>
Date: Wed, 06 Mar 2013 16:03:19 +0200
In-Reply-To: <CAEk6VBHTWn8CX7SKNVQz+T+Wqwe9Na=32Lz=+xOdqncNZFhhkQ@mail.gmail.com>
	(Nick Thomas's message of "Wed, 6 Mar 2013 00:00:13 -0700")
Message-ID: <87boawaamw.fsf@purkki.adurom.net> (sfid-20130306_150324_849535_68A73298)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Thomas <nhomas@gmail.com> writes:

> The latter iwconfig readout is from an old kernel version (3.2.39),
> where the card does indeed work. What I wish to report is that in a
> more recent kernel version (3.7.10), the card doesn't work (iwconfig
> says "no wireless extensions"). It's not a problem for me (I'm happily
> using the old kernel), but I thought it was worth reporting.

What if 3.7.10 kernel just doesn't have the old wireless extensions
(CONFIG_CFG80211_WEXT) enabled? Did you try iw which uses nl80211?

http://wireless.kernel.org/en/users/Documentation/iw

-- 
Kalle Valo
