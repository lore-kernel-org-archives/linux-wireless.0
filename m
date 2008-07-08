Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2802 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYGHTiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 15:38:12 -0400
Date: Tue, 8 Jul 2008 15:04:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/8] mac80211: move QOS control helpers into ieee80211.h
Message-ID: <20080708190452.GD30833@tuxdriver.com> (sfid-20080708_213827_704038_EEEA029D)
References: <1215540026.476.15.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1215540026.476.15.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 08, 2008 at 11:00:26AM -0700, Harvey Harrison wrote:
> Also remove the WLAN_IS_QOS_DATA inline after removing the last
> two users.  This starts moving away from using rx->fc to using
> the header frame_control directly.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

I just merged these eight from your previous sends.  Are there
changes here?  If so, could you send more patches on top?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
