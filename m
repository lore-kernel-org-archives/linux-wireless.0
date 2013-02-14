Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3BNRdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:33:03 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U62g9-0001MI-8h
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 18:33:01 +0100
Message-ID: <1360863173.8210.7.camel@jlt4.sipsolutions.net> (sfid-20130214_183307_607245_1CCBBE33)
Subject: Re: [PATCH] mac80211: don't pick up WPA vendor IE
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 18:32:53 +0100
In-Reply-To: <1360682882-23014-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_162813_143448_AD3E94BD)
References: <1360682882-23014-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130212_162813_143448_AD3E94BD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 16:28 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no use for it, WPA is entirely handled in
> wpa_supplicant in userspace, so don't pick the IE.

Applied.

johannes

