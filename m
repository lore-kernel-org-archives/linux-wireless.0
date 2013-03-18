Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3CRTOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:14:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UHfW2-00031x-FK
	for linux-wireless@vger.kernel.org; Mon, 18 Mar 2013 20:14:38 +0100
Message-ID: <1363634075.8260.7.camel@jlt4.sipsolutions.net> (sfid-20130318_201442_533140_D6DF16A1)
Subject: Re: [PATCH 1/2] mac80211: pass queue bitmap to flush operation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 18 Mar 2013 20:14:35 +0100
In-Reply-To: <1362415437-25564-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_174408_967733_EF5F37D7)
References: <1362415437-25564-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130304_174408_967733_EF5F37D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 17:43 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are a number of situations in which mac80211 only
> really needs to flush queues for one virtual interface,
> and in fact during this frames might be transmitted on
> other virtual interfaces. Calculate and pass a queue
> bitmap to the driver so it knows which queues to flush.

Applied both.

johannes

