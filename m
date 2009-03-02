Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:1822 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZCBWcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 17:32:54 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2934485wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 14:32:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49AC5E4C.2020201@hauke-m.de>
References: <49A88FF8.1040607@erley.org>
	 <43e72e890903021322n2005bf79jda8df4497498d5a6@mail.gmail.com>
	 <49AC5E4C.2020201@hauke-m.de>
Date: Mon, 2 Mar 2009 14:32:52 -0800
Message-ID: <43e72e890903021432m5c335ba3l324c0b1b0925e313@mail.gmail.com> (sfid-20090302_233257_925360_AB282DD0)
Subject: Re: [patch] Update compat.diff
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: pat-lkml <pat-lkml@erley.org>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 2, 2009 at 2:31 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Hi,
>
> this patch does not look very nice.
> The part of compat.diff for net/wireless/nl80211.c was for Johannes
> commit b8120417fc6ee609430c5436fe9ed07ffc2e63ba in wireless-testing.
> This patch was reverted in commit
> 4d8bfeff50982158c4ec4ed6c38388ba3bfc9c9c. The whole patch for nl80211.c
> is useless for kernel older than 2.6.30 and will case problems on this
> kernel. (I know it does not exist for now ;-) ).
> In my opinion it will be the best to delete the part for nl80211.c from
> compat.diff for now.

I should have reviewed this more carefully, thought it did that :)

  Luis
