Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41749 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab2GCPsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 11:48:08 -0400
Received: by yenl2 with SMTP id l2so5415463yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 08:48:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341322108.20124.3.camel@jlt3.sipsolutions.net>
References: <1341322108.20124.3.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Jul 2012 08:47:47 -0700
Message-ID: <CAB=NE6VvJ+rv4mtYMngVg==tDVZpRM2CrGJ3Yc4u7a7ZLwiGOA@mail.gmail.com> (sfid-20120703_174812_949597_D00C7132)
Subject: Re: [PATCH] compat-wireless: fix debugging in iwlwifi
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 6:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> As compat includes linux/device.h well before iwlwifi, the
> definitions from there are used without DEBUG, but iwlwifi
> defines DEBUG to get debug output. Use dev_printk instead
> of dev_dbg to get debugging back.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed, thanks!

  Luis
