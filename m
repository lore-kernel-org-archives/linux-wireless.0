Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab1IBIXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 04:23:21 -0400
Subject: Re: [PATCH v2] mac80211: stop tx before doing hw config and rate
 update
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314951719-9816-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1314951719-9816-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 10:23:11 +0200
Message-ID: <1314951791.3927.0.camel@jlt3.sipsolutions.net> (sfid-20110902_102327_846427_714097EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-02 at 13:51 +0530, Rajkumar Manoharan wrote:
> The assumption is that during the hw config, transmission was
> already stopped by mac80211. Sometimes the AP can be switching
> b/w the ht modes due to intolerant or etc where STA is in
> the middle of transmission. In such scenario, buffer overflow
> was observed at driver side. And also before updating the rate
> control, the frames are continued to xmited with older rates.
> This patch ensures that the frames are always xmitted with
> updated rates and avoid buffer overflow.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>


Thanks for your patience!

johannes

