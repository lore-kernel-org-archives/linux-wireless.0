Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:64868 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbZBLM46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 07:56:58 -0500
Received: by bwz5 with SMTP id 5so966668bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 04:56:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com>
References: <2d14e2ca0902110900r7f0b84e4k7be81827187c434@mail.gmail.com>
	 <43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com>
Date: Thu, 12 Feb 2009 13:56:55 +0100
Message-ID: <17a838c40902120456wb862200y8717a0d6a061b057@mail.gmail.com> (sfid-20090212_135702_694366_081DC353)
Subject: Re: [ath9k-devel] Radar Detection and DFS status
From: Alberto Pollastro <a.pollastro@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Green <Michael.Green@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 10:41 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>
> mac80211 or ath9k does not yet have radar detection support so
> therefore no mac80211 driver will allow you to use any beaconing mode
> (AP | IBSS | Mesh) mode on DFS channels yet.
>
> Note that not all 5 GHz channels require radar detection though so you
> could try using one of the non-DFS channels. Check 'iw list' for that.

I've checked in regdb (2009.01.30) an it reports that I can use these
frequencies (in Italy):

country IT:
    (2402 - 2482 @ 40), (N/A, 20)
    (5170 - 5250 @ 40), (N/A, 20)
    (5250 - 5330 @ 40), (N/A, 20), DFS
    (5490 - 5710 @ 40), (N/A, 27), DFS

I'm not sure, but in Italy the range 5170 - 5250 can be used only
indoor. Are indoor/outdoor channels treated differently by mac80211
and/or ath9k?

Regarding 802.11h, is its development for beaconing modes scheduled?

Thanks,
Albert.
