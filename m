Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:45547 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZBFWcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 17:32:46 -0500
Received: by gxk14 with SMTP id 14so1021952gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2009 14:32:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090205160738.990564487@sipsolutions.net>
References: <20090205160738.990564487@sipsolutions.net>
Date: Fri, 6 Feb 2009 14:32:44 -0800
Message-ID: <43e72e890902061432k2ba1a2b3o49563e496b5be0d6@mail.gmail.com> (sfid-20090206_233249_588806_400D79A7)
Subject: Re: [PATCH 00/11] mac80211 aggregation cleanups/fixes
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 5, 2009 at 8:07 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Here are a few previously posted, now rebased, patches for
> mac80211 aggregation. This is mostly preparatory for getting
> Intel aggregation working again, which is working for me but
> right now I'm unclear what sort of internal validation Intel
> folks want to do (and I hear there was one issue in testing)

Tested-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
