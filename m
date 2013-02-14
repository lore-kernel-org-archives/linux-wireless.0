Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab3BNUCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:02:14 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U650X-0003tA-0p
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 21:02:13 +0100
Message-ID: <1360872130.8210.16.camel@jlt4.sipsolutions.net> (sfid-20130214_210217_669625_0A9C87F8)
Subject: Re: [PATCH 1/2] cfg80211: advertise extended capabilities to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 21:02:10 +0100
In-Reply-To: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_150133_849592_60D3E9ED)
References: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130212_150133_849592_60D3E9ED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 15:01 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In many cases, userspace may need to know which of the
> 802.11 extended capabilities ("Extended Capabilities
> element") are implemented in the driver or device, to
> include them e.g. in beacons, assoc request/response
> or other frames. Add a new nl80211 attribute to hold
> the extended capabilities bitmap for this.

Applied both.

johannes

