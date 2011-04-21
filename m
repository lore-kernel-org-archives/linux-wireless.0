Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1DUUOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 16:14:17 -0400
Subject: RE: [PATCH] cfg80211: module_param to disable HT40 in 2.4GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FAAC2C53@SC-VEXCH1.marvell.com>
References: <1303344002-4542-1-git-send-email-bzhao@marvell.com>
	 <1303368617.3597.0.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FAAC2C53@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 22:14:16 +0200
Message-ID: <1303416856.3597.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-21 at 12:34 -0700, Bing Zhao wrote:
> > In send_wiphy? You're kidding, right? NACK. Please try to understand how
> > the code in mac80211 worked.
> 
> Hi Johannes,
> 
> Sorry, my bad. Could you please review the v2 below?

Yup, looks fine, thanks

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Please do a proper submission.

johannes

