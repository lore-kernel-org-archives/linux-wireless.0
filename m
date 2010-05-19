Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45395 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0ESBro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:47:44 -0400
Received: by pwi5 with SMTP id 5so1287791pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 18:47:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 18 May 2010 18:41:01 -0700
Message-ID: <AANLkTimfLS9S2xL7piP9r6Zd41i9utGa9YD06-hKkxhV@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] pending ath5k + antenna patches
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 18, 2010 at 6:30 PM, Bruno Randolf <br1@einfach.org> wrote:
> These are all my pending ath5k patches + the antenna support for cfg80211
> rebased against 2.6.34 and based on the previous patch i sent for stable
> ("ath5k: consistently use rx_bufsize for RX DMA").

No need to bunch these up together, in fact it would help the review
process if instead you spit these up by series which are relevant to
each other.

The stable fix is one alone, the antenna stuff should be a separate
series, then the other stuff if they are not related as a separate
series.

> Also i'd like to note that there are quite a few ath5k patches which haven't
> made it into linux-next yet. It would be great to get them into 2.6.35...

Unless its a fix, I think its too late.

  Luis
