Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41361 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875Ab1FVCRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:17:06 -0400
Received: by yia27 with SMTP id 27so155934yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 19:17:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110621T215346-191@post.gmane.org>
References: <loom.20110621T215346-191@post.gmane.org>
Date: Wed, 22 Jun 2011 10:17:05 +0800
Message-ID: <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com> (sfid-20110622_041711_342527_6375DEE5)
Subject: Re: Performance regression between Madwifi/net80211 and ath5k/mac80211
From: Adrian Chadd <adrian@freebsd.org>
To: jpo <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have you eliminated the kernel version as being the problem?


Adrian

On 22 June 2011 04:09, jpo <pommnitz@yahoo.com> wrote:
> Hello all,
> there seems to be a significant performance loss when moving from Madwifi
> to ath5k. For an embedded project we have been using Madwifi with Linux kernel
> 2.6.23. We have tested ath5k for some time and by now it seems to be stable
> enough for production use. Unfortunately it doesn't match Madwifi's performance.
> Running iperf (both, UDP and TCP) between two machines equipped with an AR5413
> with the Fedora 15 kernel and the stock Fedora 15 wireless subsystem shows a
> performance loss of about 10% relative to 2.6.23 and Madwifi-0.9.4.
> The tests where done under close to ideal lab conditions (cards connected with
> an antenna cable) running an IBSS network on channel 40 (5200MHz).
>
> Can anybody confirm this observation?
> Is there an explanation?
> Are there some tuning knobs I could try to improve the performance with
> mac80211/ath5k?
> Is the problem outside the wireless subsystem (Maybe it's the TCP/IP stack or
> something Fedora specific)?
>
> Thanks in advance.
>  Joerg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
