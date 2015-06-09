Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54864 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbbFIUFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:05:24 -0400
Message-ID: <1433880322.1892.22.camel@sipsolutions.net> (sfid-20150609_220527_299418_25E5DEF7)
Subject: Re: [PATCH v2]: mac80211: Always check rates and capabilities in
 mesh mode
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com
Cc: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Date: Tue, 09 Jun 2015 22:05:22 +0200
In-Reply-To: <557745EB.9080907@cococorp.com> (sfid-20150609_220053_201960_F15CC300)
References: <557745EB.9080907@cococorp.com>
	 (sfid-20150609_220053_201960_F15CC300)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 13:00 -0700, Alexis Green wrote:
> In mesh mode there is a race between establishing links and processing
> rates and capabilities in beacons. This is very noticeable with slow
> beacons (e.g. beacon intervals of 1s) and manifested for us as stations
> using minstrel when minstrel_ht should be used. Fixed by changing
> mesh_sta_info_init so that it always checks rates and such if it has not
> already done so.

Applied.

johannes

