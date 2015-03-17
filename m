Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53207 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbbCQKIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:08:16 -0400
Message-ID: <1426586894.1985.9.camel@sipsolutions.net> (sfid-20150317_110822_238764_BAF97829)
Subject: Re: [PATCHv2 3/3] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 11:08:14 +0100
In-Reply-To: <1425884296-7074-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150309_075909_274719_4CE55AB8)
References: <1425884296-7074-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1425884296-7074-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150309_075909_274719_4CE55AB8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 07:58 +0100, Janusz Dziedzic wrote:
> Add VHT support for IBSS. Drivers could activate
> this feature by setting NL80211_EXT_FEATURE_VHT_IBSS
> flag.

I'm assuming this needs patch 1 to go in first, so am not applying this.
If I'm wrong let me know, or just resend with the changed patch 1.

johannes

