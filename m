Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:39575 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424095Ab2LGBGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 20:06:33 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5758159lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 17:06:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354828714-7731-1-git-send-email-johannes@sipsolutions.net>
References: <1354828714-7731-1-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 17:06:11 -0800
Message-ID: <CAB=NE6U==qreEo5Xe+aT+7xD2NMExDp2_weOTtibehNdxHdX-w@mail.gmail.com> (sfid-20121207_020645_716327_398E734A)
Subject: Re: [PATCH] compat: backport unsigned netlink attribute accessors
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 1:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> These were added upstream in commit
> 4778e0be16c291ba6d9d55eeff3a6764fc84a071.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed, thanks!

  Luis
