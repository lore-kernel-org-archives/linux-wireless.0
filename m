Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59976 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZAJCNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 21:13:53 -0500
Message-ID: <20090110021351.MHLV4.64591.root@hrndva-web24-z02> (sfid-20090110_031357_520651_FE8ADF90)
Date: Fri, 9 Jan 2009 21:13:51 -0500
From: <lmage11@twcny.rr.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: Help debugging unexpected disassociations?
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Even if you strip away privacy info (and put in xx.yy.zz) it is still
> better than "read my mind and guess my problem".

Again I REALLY think that I wasn't asking that. I'm sorry
you interpreted it that way.

The configuration for the AP I'm having trouble with looks basically
like this:

network={
    ssid="MySSID"
    psk="mypsk"
}

That's really it.

> For example, this is how my deauth looks like, when NetworkManager
> cuts the connectiion, in preparation for
> suspending to RAM:
> 
> wlan2: deauthenticating by local choice (reason=3)

Yet again, I do not see this.

> Also, it is always useful to quote versions of relevant software -
> what version of wpa_supplicant, and networkmanager you are using; or
> even what distribution you are using, and hardware (64-bit, 32-bit).
> You have written 3 times and added no new info.

You need only ask. :)

I am using wpa_supplicant 0.5.7. I am aware that this is a really old version,
and I can try updating it if you think that would make a difference. I am running
on a Thinkpad T61, which is 64-bit. I think I already said which chip I'm using,
but I'll say it again. It's an IWL4965.

Ari
