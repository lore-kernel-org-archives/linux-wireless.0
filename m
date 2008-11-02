Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:8402 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYKBWdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 17:33:10 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1931280fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 14:33:08 -0800 (PST)
Message-ID: <2da21fe50811021433v45f8fd8ck302a0dcba5420f2a@mail.gmail.com> (sfid-20081102_233315_095946_96238191)
Date: Sun, 2 Nov 2008 23:33:08 +0100
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: No ProbeResp - assume out of range
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/2 Luis R. Rodriguez <mcgrof@gmail.com>:
> I'm curious if others are getting this frequently as I am:
>
> No ProbeResp from current AP 00:DE:AD:BE:EE:FF - assume out of range
>
> I get this with ath5k and ath9k, can be triggered easily in ath5k by
> doing a lot of consecutive:
>
> iwlist wlan0 scan
>
> I have to check if I can trigger this with ath9k by scanning too. We
> were seeing this with ath9k but were thinking it was ath9k related as
> it can be triggered on it after doing a large TX. Wondering if this is
> more of a generic and mac80211 issue.
>

I was hitting this quite often with ath9k when using the laptop from
my room, which is a couple of rooms away from the AP. Note however
that under MacOS X the connection is fine and stable, so it shouldn't
be a signal strength problem.

Regards,
Davide
