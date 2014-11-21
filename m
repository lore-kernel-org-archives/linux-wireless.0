Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55368 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaKUMLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 07:11:21 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Xrn3X-0007VG-Hy
	for linux-wireless@vger.kernel.org; Fri, 21 Nov 2014 13:11:19 +0100
Message-ID: <1416571877.1881.6.camel@sipsolutions.net> (sfid-20141121_131124_428211_BB9B8130)
Subject: Re: [RFC] nl80211: clarify packet statistics descriptions
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 21 Nov 2014 13:11:17 +0100
In-Reply-To: <1416570248-14253-1-git-send-email-johannes@sipsolutions.net> (sfid-20141121_124420_478299_8C0A3FE7)
References: <1416570248-14253-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20141121_124420_478299_8C0A3FE7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 12:44 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The current statistics we keep aren't very clear, some are on
> MPDUs and some on MSDUs/MMPDUs. Clarify the decriptions based
> on the counters mac80211 keeps.

Or maybe we shouldn't do this, but instead take advantage of the unclear
definitions and actually change them? I'm also adding MSDU statistics
(per TID) so we could, to avoid double-accounting, just put those into
these fields ...

johannes

