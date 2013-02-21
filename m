Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3BUTpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 14:45:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U8c5Q-0001uP-Cw
	for linux-wireless@vger.kernel.org; Thu, 21 Feb 2013 20:45:44 +0100
Message-ID: <1361475941.8327.2.camel@jlt4.sipsolutions.net> (sfid-20130221_204549_623915_D15DCAFB)
Subject: Re: [PATCH] wireless: move sequence number arithmetic to ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 21 Feb 2013 20:45:41 +0100
In-Reply-To: <1361182271-23692-1-git-send-email-johannes@sipsolutions.net> (sfid-20130218_111121_143638_F1463279)
References: <1361182271-23692-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130218_111121_143638_F1463279)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 11:11 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Move the sequence number arithmetic code from mac80211 to
> ieee80211.h so others can use it. Also rename the functions
> from _seq to _sn, they operate on the sequence number, not
> the sequence_control field.
> 
> Also move macros to convert the sequence control to/from
> the sequence number value from various drivers.

Applied.

johannes

