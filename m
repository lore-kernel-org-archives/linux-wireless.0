Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab1EMPRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:17:09 -0400
Subject: Re: [PATCH] cfg80211: advertise possible interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1305277137.3487.7.camel@jlt3.sipsolutions.net> (sfid-20110513_105908_152174_A8DD220B)
References: <1305277137.3487.7.camel@jlt3.sipsolutions.net>
	 (sfid-20110513_105908_152174_A8DD220B)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 16:55:02 +0200
Message-ID: <1305298502.3468.7.camel@jlt3.sipsolutions.net> (sfid-20110513_171714_128265_A6A3CF5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 10:58 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add the ability to advertise interface combinations in nl80211.

iw code in this branch (until patch is merged, then I'll put the code
into master):

http://git.sipsolutions.net/?p=iw.git;a=shortlog;h=refs/heads/iface-combinations

johannes

