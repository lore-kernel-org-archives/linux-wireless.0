Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42977 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423625Ab2LGBCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 20:02:51 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so38366lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 17:02:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-16-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-16-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 17:02:30 -0800
Message-ID: <CAB=NE6Wf6BrMudUDVbMy1rCa5Vi=jbbwHD4Fv3+UspiwsihcpA@mail.gmail.com> (sfid-20121207_020257_998844_A00204C8)
Subject: Re: [PATCH 15/24] regulatory: simplify freq_reg_info_regd
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The function itself has dual-purpose: it can
> retrieve from a given regdomain or from the
> globally installed one. Change it to have a
> single purpose only: to look up from a given
> regdomain. Pass the correct regdomain in the
> freq_reg_info() function instead.
>
> This also changes the locking rules for it,
> no locking is required any more.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
