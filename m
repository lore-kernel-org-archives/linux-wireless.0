Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44843 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEVPQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 11:16:11 -0400
Message-ID: <1400771757.4174.37.camel@jlt4.sipsolutions.net> (sfid-20140522_171614_748051_9607F002)
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@noack.us>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 22 May 2014 17:15:57 +0200
In-Reply-To: <3893194.GDQagdLGN9@desktop.local> (sfid-20140522_170627_649541_A6B9489E)
References: <3893194.GDQagdLGN9@desktop.local>
	 (sfid-20140522_170627_649541_A6B9489E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 17:06 +0200, Henning Rogge wrote:
> From: Henning Rogge <hrogge@gmail.com>
> 
> This patch is a preparation for exporting the MPP data of the 802.11s
> implementation via netlink to userspace. It unifies the content of the
> mesh_paths and mpp_paths tables in mesh_pathtbl.c without changing
> the behavior of the code.

Code removal always *seems* good, but I can't really say much about
this :-)

>  void ieee80211s_stop(void);
> +
>  #else

This I'd rather avoid though.

johannes

