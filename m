Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:24:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwAZ5-0007Cl-Lu
	for linux-wireless@vger.kernel.org; Tue, 31 Jul 2012 13:24:39 +0200
Message-ID: <1343733877.4474.1.camel@jlt3.sipsolutions.net> (sfid-20120731_132443_247500_D2BC1A60)
Subject: Re: [PATCH] mac80211: rename sta to new_sta
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 31 Jul 2012 13:24:37 +0200
In-Reply-To: <1343387377-7768-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130943_742391_03E0FF36)
References: <1343387377-7768-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120727_130943_742391_03E0FF36)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:09 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In ieee80211_prep_connection(), the station (if not NULL)
> is the new station (representing the AP) that needs to be
> added. Rename the variable to "new_sta" to clarify this.

Applied.

johannes

