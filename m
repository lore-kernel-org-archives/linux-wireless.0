Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:63321 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZLWCky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 21:40:54 -0500
Received: by iwn1 with SMTP id 1so4866532iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 18:40:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19249.32885.877602.60242@gargle.gargle.HOWL>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL> <20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux> <20091222165528.GE4385@tux> <20091222175939.GF4385@tux>
	<19249.32885.877602.60242@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Dec 2009 18:40:33 -0800
Message-ID: <43e72e890912221840g7840cfafj559b1919e4dd5f19@mail.gmail.com>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 6:29 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis Rodriguez wrote:
>> I just tried adding the PM stuff over ath9k_remove_interface and I still get the
>> issue. The patch is below.
>
> The HW is not accessed in ->remove_interface(), so this patch is not necessary.

How about when remove_interface calls ath9k_hw_stoptxdma() ?

  Luis
