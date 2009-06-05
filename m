Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:52686 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFEOVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 10:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <4A2925F8.6060602@openwrt.org>
References: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
	 <4A2925F8.6060602@openwrt.org>
Date: Fri, 5 Jun 2009 10:21:42 -0400
Message-ID: <b6c5339f0906050721k1ed672a0xf6123fa092cb76dd@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix minstrel single-rate memory corruption
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, rathamahata@gmail.com,
	ognjen.maric@gmail.com, rjw@sisk.pl, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 5, 2009 at 10:04 AM, Felix Fietkau<nbd@openwrt.org> wrote:
>> John & Felix, the patch itself may be too subtle so feel free to do it a
>> different way.  However this is as minimal as it gets so I hope it can
>> be applied quickly to stable, and mainline if not too late.
>
> How about changing the type of sample_idx to signed instead of casting
> it? It's just a cosmetic thing, so even if you leave at this you get my

Yeah, that is a better option for 2.6.31.  I would be a bit more
comfortable with this version for now though since it's exactly
the code I tested.

> Acked-by: Felix Fietkau <nbd@openwrt.org>

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com
