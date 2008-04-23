Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:64109 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbYDWAyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 20:54:36 -0400
Received: by wa-out-1112.google.com with SMTP id m16so4238237waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2008 17:54:35 -0700 (PDT)
Message-ID: <9f33c5230804221754h624536cakf16e869666d58a01@mail.gmail.com> (sfid-20080423_025527_044981_C6868F08)
Date: Tue, 22 Apr 2008 20:54:35 -0400
From: "cao jing" <caojing.china@gmail.com>
To: "Luis Carlos Cobo" <luisca@cozybit.com>
Subject: Re: mesh point beacon sending problem for 802.11s
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1208911719.13800.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <9f33c5230804152338va7a9118tdd869f2196a6742b@mail.gmail.com>
	 <1208911719.13800.2.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks very much. Actually, I found ieee80211_beacon_get already. But
the problem I met now is that the ath5k driver doesn't work well with
mac80211 to send beacons. Open11s developers use different devices and
different driver to support mesh point sending beacons.

Jing

On Tue, Apr 22, 2008 at 8:48 PM, Luis Carlos Cobo <luisca@cozybit.com> wrote:
>
> On Wed, 2008-04-16 at 02:38 -0400, cao jing wrote:
>  > Hi,
>  >
>  > Open11s developers said it's already supported the Mesh peer link
>  > establishment. But I can't find any code for mesh point to send
>  > beacons. How come the mesh point establish a peer link without
>  > beacons.
>
>  That you did not find the code does not necessarily means it is not
>  there ;-). Check out net/mac80211/tx.c:ieee80211_beacon_get()
>
>  I assume you are looking at wireless-testing.
>
>  Cheers!
>
>  --
>  Luis Carlos Cobo Rus       GnuPG ID: 44019B60
>  cozybit Inc.
>
>
>
