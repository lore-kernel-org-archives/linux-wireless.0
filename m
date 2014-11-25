Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37624 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaKYLAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 06:00:53 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so357199pab.33
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 03:00:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net>
References: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 25 Nov 2014 19:00:53 +0800
Message-ID: <CAFuUQkh-fX3rz9+FUBfF8GxbkxrZxP7-iJwmypo5EEANwODqzQ@mail.gmail.com> (sfid-20141125_120059_502403_E712C430)
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe requests
From: YanBo <dreamfly281@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 6:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> If there are no channels allowing 80 MHz to be used, then the
> station isn't really VHT capable even if the driver and device
> support it in general. In this case, exclude the VHT capability
> IE from probe request frames.
>

FYI, there are some new devices could support the VHT even at 20Mhz
band 2.4G mode.

BR /Yanbo
