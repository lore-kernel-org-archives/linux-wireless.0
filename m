Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:42:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TaSYl-0007XI-IZ
	for linux-wireless@vger.kernel.org; Mon, 19 Nov 2012 15:42:51 +0100
Message-ID: <1353336199.18299.13.camel@jlt4.sipsolutions.net> (sfid-20121119_154255_707240_14E6CA83)
Subject: Re: [PATCH] mac80211: introduce IEEE80211_NUM_TIDS and use it
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 15:43:19 +0100
In-Reply-To: <1352978984-15876-1-git-send-email-johannes@sipsolutions.net> (sfid-20121115_122917_415702_1452D5AB)
References: <1352978984-15876-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121115_122917_415702_1452D5AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-15 at 12:29 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Introduce IEEE80211_NUM_TIDS in the generic 802.11
> header file and use it in place of STA_TID_NUM and
> NUM_RX_DATA_QUEUES which are both really the number
> of TIDs.

Applied.

johannes

