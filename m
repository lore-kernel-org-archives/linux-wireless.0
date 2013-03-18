Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3CRTCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:02:52 -0400
Message-ID: <1363633367.8260.3.camel@jlt4.sipsolutions.net> (sfid-20130318_200257_179879_96C00473)
Subject: Re: [PATCH] mac80211: add driver callback for per-interface
 multicast filter
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Mon, 18 Mar 2013 20:02:47 +0100
In-Reply-To: <1363007951-31289-1-git-send-email-johannes@sipsolutions.net> (sfid-20130311_141922_966223_D68C35E5)
References: <1363007951-31289-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130311_141922_966223_D68C35E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-11 at 15:19 +0200, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> Some devices have multicast filter capability for each individual
> virtual interface rather than just a global one. Add an interface
> specific driver callback allowing such drivers to configure this.

Applied (again :) )

johannes

