Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:43698 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab0LVTkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:40:17 -0500
Received: by iyf40 with SMTP id 40so2421225iyf.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 11:40:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=GUN7=AQAAvmgADgwHtcquNiZbWEtgCoJpC4Fv@mail.gmail.com>
References: <AANLkTi=GUN7=AQAAvmgADgwHtcquNiZbWEtgCoJpC4Fv@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Dec 2010 14:39:56 -0500
Message-ID: <AANLkTikGzNSWGKfFpV0CPLg8dQbjd3YN8T_ebQbfmP_r@mail.gmail.com>
Subject: Re: [ath9k] skbuff alloc of size 3872 failed
To: Matt Turner <mattst88@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Michael Guntsche <mike@it-loops.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 2:22 PM, Matt Turner <mattst88@gmail.com> wrote:
> With the ath9k driver, I get "skbuff alloc of size 3872 failed"
>
> I hit this again today after not using wireless for quite sometime. It
> looks like it was originally reported against 2.6.35-rc1. Eric Dumazet
> provided a patch which fixed the issue, but apparently it's still not
> upstream. Why is this?
>
> If it is suitable for upstream inclusion, please take my Tested-by:
> Matt Turner <mattst88@gmail.com>
>
> https://patchwork.kernel.org/patch/104271/

Never saw this patch, can this be posted to linux-wireless with a proper SOB?

 Luis
