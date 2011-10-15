Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34874 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1JOHjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 03:39:22 -0400
Received: by wyg36 with SMTP id 36so741429wyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 00:39:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmomy-LGg=mh5=GqmqWuj7T8b1+oV3oaBSZpf6orJSGPTQg@mail.gmail.com>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<CAJ-Vmomy-LGg=mh5=GqmqWuj7T8b1+oV3oaBSZpf6orJSGPTQg@mail.gmail.com>
Date: Sat, 15 Oct 2011 11:39:21 +0400
Message-ID: <CAN=pzd+8wq4Mw3Ww8jTOYNk-Q2EYOvtdgHPi=RMQqbJvJRZtdw@mail.gmail.com> (sfid-20111015_093930_401020_85AE1FFE)
Subject: Re: Ath9k, single antenna on ar9280
From: Stanislav Demakov <s.demakov@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, before, I did this:

echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/rx_chainmask
echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/tx_chainmask

So what exactly changed now after they added set\get_antenna functions
to the driver?

2011/10/15 Adrian Chadd <adrian@freebsd.org>:
> .. well, that's basically how you convince the MIMO radios to work in 1x1 mode.
>
>
>
> Adrian
>
