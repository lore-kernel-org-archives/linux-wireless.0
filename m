Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:47934 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbXKWB0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 20:26:10 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IvNJ3-0005lK-Hc
	for linux-wireless@vger.kernel.org; Thu, 22 Nov 2007 20:26:09 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Pavel Roskin <proski@gnu.org>
To: Ehud Gavron <gavron@wetwork.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <47462A72.8010303@wetwork.net>
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <1195736752.6323.97.camel@johannes.berg>
	 <20071122132635.GA3372@tuxdriver.com> <1195777405.11966.12.camel@dv>
	 <47462A72.8010303@wetwork.net>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 20:26:05 -0500
Message-Id: <1195781165.11966.18.camel@dv> (sfid-20071123_012616_541126_92D85987)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-11-22 at 18:18 -0700, Ehud Gavron wrote:

> 2. dmesg repeats: wlan0: authentication with AP 00:50:bf:b1:da:64 timed out

I think it's an unrelated hardware specific issue.  mac80211 tried to
associate but failed.

-- 
Regards,
Pavel Roskin

