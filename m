Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62617 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab2LMWLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:11:45 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2248800lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:11:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-20-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-20-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:11:16 -0800
Message-ID: <CAB=NE6UrhZ1K17Bd=qorjQ6mhpfCTgR4ctehuDu-2v6-2g44qA@mail.gmail.com> (sfid-20121213_231149_105064_2251CD05)
Subject: Re: [PATCH 19/24] regulatory: remove handling of channel bandwidth
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The channel bandwidth handling isn't really quite right,
> it assumes that a 40 MHz channel is really two 20 MHz
> channels, which isn't strictly true. This is the way the
> regulatory database handling is defined right now though
> so remove the logic to handle other channel widths.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I didn't see the replacement work in place but I assume its coming
through RFCs or already posted so:

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

I'm done reviewing this series!

  Luis
