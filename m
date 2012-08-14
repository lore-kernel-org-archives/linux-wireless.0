Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43507 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2HNBas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 21:30:48 -0400
Received: by ggdk6 with SMTP id k6so3976224ggd.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2012 18:30:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344886886-17983-1-git-send-email-hauke@hauke-m.de>
References: <1344886886-17983-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Aug 2012 18:30:27 -0700
Message-ID: <CAB=NE6Uoe5D04BrAN_CJTHzkaT4Bj9ygDo_BVKecNqUP-vdWEg@mail.gmail.com> (sfid-20120814_033051_697085_7F433BEA)
Subject: Re: [PATCH] compat-wireless: make patches apply again
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2012 at 12:41 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Some parts of 11-dev-pm-ops.patch for iwlegacy went upstream in:
> commit 450e9038ee65e3246b2a942669fc79001466f9be
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Tue Aug 7 21:46:44 2012 +0200
>
>     iwlegacy: clean up suspend/resume
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

applied and pushed, thanks!!

  Luis
