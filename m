Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36741 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab2E2XQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 19:16:56 -0400
Received: by yenm10 with SMTP id m10so2582876yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 16:16:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338331182-29589-2-git-send-email-hauke@hauke-m.de>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de> <1338331182-29589-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 29 May 2012 16:16:35 -0700
Message-ID: <CAB=NE6XuJKkZTAABX614eih7Okn68hj_RD_MSLv1Xg18Jy1d4g@mail.gmail.com> (sfid-20120530_011701_001357_9594C0CD)
Subject: Re: [PATCH 1/8] compat-wireless: make patches apply again
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 3:39 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Oops, I had just pushed out some changes to make patches apply but --
I hadn't started to address compilation yet, I think just patch 1
addresses application of patches, the rest seem to address compilation
so I'll try to apply the rest of the series. If you can rebase that'd
be great, I'll stop doing stuff right away.

  Luis
