Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63778 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2E3AEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 20:04:02 -0400
Received: by yhmm54 with SMTP id m54so2830107yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 17:04:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XuJKkZTAABX614eih7Okn68hj_RD_MSLv1Xg18Jy1d4g@mail.gmail.com>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
 <1338331182-29589-2-git-send-email-hauke@hauke-m.de> <CAB=NE6XuJKkZTAABX614eih7Okn68hj_RD_MSLv1Xg18Jy1d4g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 29 May 2012 17:03:41 -0700
Message-ID: <CAB=NE6WgLbv+vx2V2nZ-W+8wtz_1JfooYxF99oDaLH8q33Np8Q@mail.gmail.com> (sfid-20120530_020410_599728_B9A03EFD)
Subject: Re: [PATCH 1/8] compat-wireless: make patches apply again
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 4:16 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, May 29, 2012 at 3:39 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>
> Oops, I had just pushed out some changes to make patches apply but --
> I hadn't started to address compilation yet, I think just patch 1
> addresses application of patches, the rest seem to address compilation
> so I'll try to apply the rest of the series. If you can rebase that'd
> be great, I'll stop doing stuff right away.

Actually I managed to apply them all, test compiling now!

  Luis
