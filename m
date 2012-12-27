Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2L0NH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 08:07:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ToDBl-00059R-UH
	for linux-wireless@vger.kernel.org; Thu, 27 Dec 2012 14:07:58 +0100
Message-ID: <1356613701.15149.12.camel@jlt4.sipsolutions.net> (sfid-20121227_140803_018085_7A405F6A)
Subject: Re: [PATCH] mac80211: restrict assoc request VHT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 27 Dec 2012 14:08:21 +0100
In-Reply-To: <1356003626-23425-1-git-send-email-johannes@sipsolutions.net> (sfid-20121220_124010_941702_1EA3B5DA)
References: <1356003626-23425-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121220_124010_941702_1EA3B5DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 12:40 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In interoperability testing some APs showed bad behaviour
> if some of the VHT capabilities of the station are better
> than their own. Restrict the assoc request parameters
>  - beamformee capabable,
>  - RX STBC and
>  - RX MCS set
> to the subset that the AP can support.

Applied.

johannes

