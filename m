Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYJ3ELX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 00:11:23 -0400
Subject: Re: [PATCH] don't use net/ieee80211.h
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225243531.1369.18.camel@johannes.berg>
References: <1225243531.1369.18.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 00:09:47 -0400
Message-Id: <1225339787.32092.16.camel@localhost.localdomain> (sfid-20081030_051128_015010_F3B07044)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 02:25 +0100, Johannes Berg wrote:
> Convert all the drivers using net/ieee80211.h to use linux/ieee80211.h.
> Contains a bugfix in libertas where the SSID parsing could overrun the
> buffer when the AP sends invalid information.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/airo.c                |   50 +++++++++---------
>  drivers/net/wireless/libertas/assoc.c      |   18 +++---
>  drivers/net/wireless/libertas/cmd.c        |    5 -
>  drivers/net/wireless/libertas/dev.h        |    7 ++
>  drivers/net/wireless/libertas/main.c       |    3 -
>  drivers/net/wireless/libertas/persistcfg.c |    2 
>  drivers/net/wireless/libertas/scan.c       |   77 ++++++++++++++---------------
>  drivers/net/wireless/libertas/scan.h       |    4 +
>  drivers/net/wireless/libertas/types.h      |    5 -
>  drivers/net/wireless/libertas/wext.c       |    1 

airo & libertas:

Acked-by: Dan Williams <dcbw@redhat.com>



