Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3A2KxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 05:53:08 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U08oM-00077M-Qv
	for linux-wireless@vger.kernel.org; Tue, 29 Jan 2013 11:53:07 +0100
Message-ID: <1359456812.8108.3.camel@jlt4.sipsolutions.net> (sfid-20130129_115311_893557_57BF8B50)
Subject: Re: [PATCH] cfg80211: add SME state to warning in
 __cfg80211_mlme_disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 29 Jan 2013 11:53:32 +0100
In-Reply-To: <1359235036-13086-1-git-send-email-johannes@sipsolutions.net> (sfid-20130126_221701_968936_C1054DCD)
References: <1359235036-13086-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130126_221701_968936_C1054DCD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 22:17 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The warning here occasionally triggers but we haven't
> found the cause yet. It's a valid warning since if it
> triggers the SME state got confused, so add the SME
> state to it to help narrow it down in the future.

Applied.

johannes

