Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:28214 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763385AbYEHPBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 11:01:32 -0400
Received: by nf-out-0910.google.com with SMTP id d3so418768nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 08:01:30 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 015-mac80211-tx-info-skb-cb.patch
Date: Thu, 8 May 2008 17:10:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <200805081503.41025.IvDoorn@gmail.com> <200805081657.27976.IvDoorn@gmail.com> <1210258216.3547.56.camel@johannes.berg>
In-Reply-To: <1210258216.3547.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805081710.03869.IvDoorn@gmail.com> (sfid-20080508_170032_474553_F027E06A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 May 2008, Johannes Berg wrote:
> 
> > No I haven't, I had been compiling mac80211 with VERBOSE_DEBUG on ever
> > since I added the patches from your tree to rt2x00.git so I never noticed this
> > bug. I just received the bugreport from somebody at the rt2x00 forum. :)
> 
> Then somebody else told me. Or I found it in your tree :)

ok. :)

> > Since rt2x00.git contains your patches from a week ago, I did check if the
> > bug was still present in your latest version.
> > Anyway the important thing is that you have the fix. ;)
> 
> Right :) I'm pretty much done with the skb->cb conversion too except for
> ath5k (nick) and rt2x00 (you)

I'm going to rebase rt2x00.git this weekend to update from wireless-testing,
since the skb->cb patches now depends on HW crypto which is not ready
for upstream yet, I am going to reverse the patch order so the skb->cb patches
and some other updates can go upstream more easily.

Ivo
