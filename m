Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37585 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab0G1VBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 17:01:43 -0400
Received: by yxg6 with SMTP id 6so1117953yxg.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 14:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280334711-6141-1-git-send-email-linville@tuxdriver.com>
References: <1280334711-6141-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 28 Jul 2010 14:01:21 -0700
Message-ID: <AANLkTim_Yr0Hx58GHYPfiPxRBWjspuFUd64epUHn_4La@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add led_disable module option
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 9:31 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> Not everyone agrees about LED behaviour...give them an escape hatch that
> will at least stop the lights from annoying them.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

I wonder if we can just do this on cfg80211 through a debugfs knob,
which would take care of all device drivers?

  Luis
