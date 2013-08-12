Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3HLMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 08:09:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1V8qwA-0008VS-Gh
	for linux-wireless@vger.kernel.org; Mon, 12 Aug 2013 14:09:26 +0200
Message-ID: <1376309363.11514.17.camel@jlt4.sipsolutions.net> (sfid-20130812_140929_684368_43C73412)
Subject: Re: [PATCH] mac80211: add control port protocol TX control flag
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 12 Aug 2013 14:09:23 +0200
In-Reply-To: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net> (sfid-20130806_115746_886863_FC07E6F8)
References: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130806_115746_886863_FC07E6F8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-06 at 11:57 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> A lot of drivers check the frame protocol for ETH_P_PAE,
> for various reasons (like making those more reliable).
> Add a new flags bitmap to the TX control info and a new
> flag indicating the control port protocol is in use to
> let all drivers also apply such logic to other control
> port protocols, should they be configured.

Applied (with fix for the problem Eliad pointed out, and the change-id
removed)

johannes

