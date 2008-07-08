Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:6745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYGHTrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 15:47:25 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1665914waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 12:47:22 -0700 (PDT)
Subject: Re: [PATCH 1/8] mac80211: move QOS control helpers into ieee80211.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080708190452.GD30833@tuxdriver.com>
References: <1215540026.476.15.camel@brick>
	 <20080708190452.GD30833@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 12:47:21 -0700
Message-Id: <1215546441.476.26.camel@brick> (sfid-20080708_214729_000656_01FE787F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-08 at 15:04 -0400, John W. Linville wrote:
> On Tue, Jul 08, 2008 at 11:00:26AM -0700, Harvey Harrison wrote:
> > Also remove the WLAN_IS_QOS_DATA inline after removing the last
> > two users.  This starts moving away from using rx->fc to using
> > the header frame_control directly.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> I just merged these eight from your previous sends.  Are there
> changes here?  If so, could you send more patches on top?

Sorry, I sent the wrong batch, ignore these 8 as they are the ones you 
just merged.

No changes from the previous send.

My bad,

Harvey

