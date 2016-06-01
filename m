Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33993 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbcFAEG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 00:06:58 -0400
Received: by mail-qg0-f44.google.com with SMTP id p34so32438620qgp.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 21:06:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160529214059.GA15677@localhost>
References: <20160529214059.GA15677@localhost>
Date: Tue, 31 May 2016 22:06:57 -0600
Message-ID: <CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com> (sfid-20160601_060702_678405_20B60373)
Subject: Re: wireless-testing on 4.7
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Today I compiled 4.6+ and pulled sources today
iwlwifi isn't super smooth.

[  112.345457] wlp4s0: authenticate with 00:30:44:1d:cf:2b
[  112.349002] wlp4s0: send auth to 00:30:44:1d:cf:2b (try 1/3)
[  112.349647] wlp4s0: authenticated
[  112.352456] wlp4s0: associate with 00:30:44:1d:cf:2b (try 1/3)
[  112.353764] wlp4s0: RX AssocResp from 00:30:44:1d:cf:2b (capab=0x11
status=0 aid=3)
[  112.355035] wlp4s0: associated
[  112.355393] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
[  118.616327] wlp4s0: deauthenticated from 00:30:44:1d:cf:2b (Reason:
15=4WAY_HANDSHAKE_TIMEOUT)
[  128.673812] wlp4s0: authenticate with 00:30:44:1d:cf:2b
[  128.676997] wlp4s0: send auth to 00:30:44:1d:cf:2b (try 1/3)
[  128.677648] wlp4s0: authenticated
[  128.678691] wlp4s0: associate with 00:30:44:1d:cf:2b (try 1/3)
[  128.679807] wlp4s0: RX AssocResp from 00:30:44:1d:cf:2b (capab=0x11
status=0 aid=3)
[  128.681198] wlp4s0: associated

I never experienced the 4 way handshake 802.11i timeout in my home setup.
With other setups plenty of times, especially with mediatek drivers. :)
If you wish I can sniff and see which side is at fault.
Thanks,

Reinoud.


On Sun, May 29, 2016 at 3:40 PM, Bob Copeland <me@bobcopeland.com> wrote:
> Since Linus released 4.7-rc1 today, I've resumed wireless-testing
> updates since its merge window hiatus, with tag wt-2016-05-29.
>
> Please test and let me know of any issues.
>
> --
> Bob Copeland %% http://bobcopeland.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
