Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:38262 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2LGAfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:35:06 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5746736lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:35:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-11-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-11-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:34:44 -0800
Message-ID: <CAB=NE6U7DAM1LtCmYwiB8DEby=LTvShV1QxEn5bpS1S=-hEsLw@mail.gmail.com> (sfid-20121207_013511_463436_BD1D3760)
Subject: Re: [PATCH 10/24] cfg80211: remove wiphy_idx_valid
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This is pretty much useless since get_wiphy_idx()
> always returns true since it's always called with
> a valid wiphy pointer.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

This seems more like a rename of the stale -> invalid and unwrapping
the check into code in place, and then removal of some checks you are
sure are unnecessary.

  Luis
