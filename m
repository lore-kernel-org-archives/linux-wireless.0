Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38835 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaFWVVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 17:21:16 -0400
Received: by mail-lb0-f176.google.com with SMTP id w7so5377692lbi.35
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 14:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <539B96F7.9090101@gmail.com>
References: <539B7019.1050801@gmail.com> <539B7639.30104@openwrt.org>
 <539B85F0.3090004@gmail.com> <539B96F7.9090101@gmail.com>
From: Mathy Vanhoef <vanhoefm@gmail.com>
Date: Mon, 23 Jun 2014 23:20:54 +0200
Message-ID: <CAFXAJYwL6Qo95mHn-sD52ryVRuPh1fmoZMVmCNJkhsu0mhm1KA@mail.gmail.com> (sfid-20140623_232120_134497_A8A240A5)
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: capture CCK and OFDM restarts
To: Gus Wirth <gwirth79@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm sure the spelling error can be fixed when applying the patch.

This (and the previous patch) is useful for people using monitor mode
to diagnose network problems, monitor traffic, research things, etc.
So it would be nice to have it included!

On Sat, Jun 14, 2014 at 2:27 AM, Gus Wirth <gwirth79@gmail.com> wrote:
> On 2014-06-13 16:14, Mathy Vanhoef wrote:
> [snip]
>> Just saw a spelling mistake in the comment, s/Threat/Treat.
>
> One more mistake in the comment.
>
> Change the word "of" to "or":
>
>
> ...underwent a CCK of OFDM reset...
>
> should be
>
> ...underwent a CCK or OFDM reset...
>
> Gus
