Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15334 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IOMIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:08:11 -0400
Date: Thu, 15 Sep 2011 17:38:47 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] wireless: Do not allow disabled channel in scan request
Message-ID: <20110915120846.GA4025@vmraj-lnx.users.atheros.com> (sfid-20110915_140814_963906_FBD3357F)
References: <1316088181-3869-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1316088306.3992.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1316088306.3992.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 02:05:06PM +0200, Johannes Berg wrote:
> On Thu, 2011-09-15 at 17:33 +0530, Rajkumar Manoharan wrote:
> > cfg80211_conn_scan allows disabled channels at scan request.
> > Hence probe request was seen at the disabled one. This patch
> > ensures that disabled channel never be added into the scan
> > request's channel list.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Good catch. We should probably refactor this later to go through a
> single point...
> 
True. Thanks for the review

--
Rajkumar
