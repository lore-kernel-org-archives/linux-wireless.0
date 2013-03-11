Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3CKHf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 03:35:28 -0400
Message-ID: <1362987319.5284.0.camel@jlt4.sipsolutions.net> (sfid-20130311_083540_333236_79D59F10)
Subject: Re: [PATCH] mac80211: add driver callback for per-interface
 multicast filter
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Mon, 11 Mar 2013 09:35:19 +0200
In-Reply-To: <1362741267-19387-1-git-send-email-johannes@sipsolutions.net> (sfid-20130308_121443_550811_F496A6E2)
References: <1362741267-19387-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130308_121443_550811_F496A6E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-08 at 12:14 +0100, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> Some devices have multicast filter capability for each individual
> virtual interface rather than just a global one. Add an interface
> specific driver callback allowing such drivers to configure this.

Applied.

johannes

