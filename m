Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41606 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaJFOXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:23:52 -0400
Message-ID: <1412605426.3098.15.camel@jlt4.sipsolutions.net> (sfid-20141006_162355_168087_E416ECCC)
Subject: Re: [PATCH] iw: support setting vdev MAC during creation.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Oct 2014 16:23:46 +0200
In-Reply-To: <1412102935-30887-1-git-send-email-greearb@candelatech.com> (sfid-20140930_204916_791554_FDE9BF7C)
References: <1412102935-30887-1-git-send-email-greearb@candelatech.com>
	 (sfid-20140930_204916_791554_FDE9BF7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-30 at 11:48 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This saves an extra call to change it later, and will
> also keep udev from potentially messing with a vdev
> it should not be messing with.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  info.c      |  2 ++
>  interface.c | 20 ++++++++++++++++++--
>  nl80211.h   | 30 ++++++++++++++++++++++++++++++

Please don't update nl80211.h, I'll do it as appropriate. In any case, I
haven't seen a kernel patch to add the MAC_ON_CREATE flag, so I'm
dropping this patch for now.

(Please also Cc me in the future - I have ~500+ emails per week to go
through and was just on vacation for three weeks, making it likely that
I miss something I wasn't Cc'ed on)

johannes


