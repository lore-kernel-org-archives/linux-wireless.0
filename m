Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751114Ab2KHJsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 04:48:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWOiM-0001s4-LC
	for linux-wireless@vger.kernel.org; Thu, 08 Nov 2012 10:47:58 +0100
Message-ID: <1352368115.9870.5.camel@jlt4.sipsolutions.net> (sfid-20121108_104817_576651_914CDAA0)
Subject: Re: [PATCH] mac80211: fix TX error path
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 08 Nov 2012 10:48:35 +0100
In-Reply-To: <1352293405-27692-1-git-send-email-johannes@sipsolutions.net> (sfid-20121107_140302_585568_7ECC7434)
References: <1352293405-27692-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121107_140302_585568_7ECC7434)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 14:03 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> One error path in ieee80211_subif_start_xmit() will
> double-free the SKB. Set it to NULL to prevent that.
> 
> This issue was introduced by my channel context
> changes.

Applied.

johannes

