Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49504 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZFNSD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2009 14:03:59 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 14 Jun 2009 11:03:43 -0700
Subject: RE: [PATCH] mac80211: add queue debugfs file
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3556EE5633@orsmsx506.amr.corp.intel.com>
References: <1244993859.13033.22.camel@johannes.local>
 <87tz2in1qj.fsf@litku.valot.fi>
In-Reply-To: <87tz2in1qj.fsf@litku.valot.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same for iwlwifi, it is a very helpful debugging aid.

Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                 
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
 

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Kalle Valo
Sent: Sunday, June 14, 2009 10:51 AM
To: Johannes Berg
Cc: John Linville; linux-wireless
Subject: Re: [PATCH] mac80211: add queue debugfs file

Johannes Berg <johannes@sipsolutions.net> writes:

> I suspect that some driver bugs can cause queues to be
> stopped while they shouldn't be, but it's hard to find
> out whether that is the case or not without having any
> visible information about the queues. This adds a file
> to debugfs that allows us to see the queues' statuses.

I have to admit that I have managed to do that sometimes with wl12xx, so
this is a welcomed debugging aid :)

-- 
Kalle Valo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
