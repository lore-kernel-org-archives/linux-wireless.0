Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54836 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbbFITyB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 15:54:01 -0400
Message-ID: <1433879639.1892.20.camel@sipsolutions.net> (sfid-20150609_215404_747646_3E813B46)
Subject: Re: [PATCH] mac80211: Fix incorrectly named last_hop_metric
 variable in mesh_rx_path_sel_frame
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com
Cc: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Date: Tue, 09 Jun 2015 21:53:59 +0200
In-Reply-To: <5571FBFA.9060902@cococorp.com> (sfid-20150605_214446_863932_9DD1F8E8)
References: <5571FBFA.9060902@cococorp.com>
	 (sfid-20150605_214446_863932_9DD1F8E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-05 at 12:43 -0700, Alexis Green wrote:
> The last hop metric should refer to link cost (this is how
> hwmp_route_info_get uses it for example). But in mesh_rx_path_sel_frame
> we are not dealing with link cost but with the total cost to the origin
> of a PREQ or PREP.
> 
> Signed-off-by: Alexis Green <agreen@cococorp.com>
> CC: Jesse Jones <jjones@cococorp.com>

Applied. This one worked, but the other ones you sent didn't.

johannes

