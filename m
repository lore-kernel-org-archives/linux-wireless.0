Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41382 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1JQQpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 12:45:54 -0400
Received: by eye27 with SMTP id 27so3151725eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 09:45:53 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: Re: [PATCH 1/2] nl80211: Add sta_flags to the station info
Date: Mon, 17 Oct 2011 18:43:57 +0200
Message-ID: <1787802.SVkvIClvU7@helmutmobil.site> (sfid-20111017_184558_011041_36ABE455)
In-Reply-To: <1318869577.3960.12.camel@jlt3.sipsolutions.net>
References: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com> <1318869577.3960.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 17. Oktober 2011, 18:39:37 schrieb Johannes Berg:
> On Thu, 2011-10-13 at 16:30 +0200, Helmut Schaa wrote:
> > Reuse the already existing struct nl80211_sta_flag_update to specify
> > both, a flag mask and the flag set itself. This means
> > nl80211_sta_flag_update is now used for setting station flags and also
> > for getting station flags.
> 
> Got a corresponding iw patch?

Yup. Haven't found the time to send it out though...
