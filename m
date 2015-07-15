Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35471 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbGOFmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2015 01:42:22 -0400
Received: by wgjx7 with SMTP id x7so24132492wgj.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 22:42:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOtFK_UO_0z2h+i0Q33GJ4kqYTpQrFyVdRMqsnA2j4AzPSALTg@mail.gmail.com>
References: <CAOtFK_UO_0z2h+i0Q33GJ4kqYTpQrFyVdRMqsnA2j4AzPSALTg@mail.gmail.com>
Date: Wed, 15 Jul 2015 07:42:20 +0200
Message-ID: <CALhHN=p2VeaS+o353SUwoe7H3RUyuZv6MAFmu_ks_jO-xAtH6g@mail.gmail.com> (sfid-20150715_074226_349185_684BC043)
Subject: Re: [ath9k-devel] Wi-Fi Direct multi-role support in ath9k
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Adrien Decostre <ad.decostre@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 July 2015 at 16:31, Adrien Decostre <ad.decostre@gmail.com> wrote:
> Dear all,
>
>
>
> I am experimenting a bit with Wi-Fi Direct on top of the ath9k driver and I
> am wondering if it is possible to operate at the same moment, on the same
> IEEE802.11n module, a software AP for an infrastructure Wi-Fi network (e.g.
> by using hostapd) and a soft AP for a Wi-Fi Direct link.
>
> As far as I understand, for this, the driver needs to support the
> “multi-role” feature. Is it right?
>
> Is this feature already supported by the ath9k driver?
>
You should load driver with use_chanctx=1 (before compile with
CONFIG_ATH9K_CHANNEL_CONTEXT)
I tested AP and P2P_GO on different channels using AR9462.

BR
Janusz
