Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2L0NIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 08:08:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ToDCR-00059t-MQ
	for linux-wireless@vger.kernel.org; Thu, 27 Dec 2012 14:08:39 +0100
Message-ID: <1356613743.15149.13.camel@jlt4.sipsolutions.net> (sfid-20121227_140843_073801_16416E03)
Subject: Re: [PATCH] cfg80211: move some AP code to right file
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 27 Dec 2012 14:09:03 +0100
In-Reply-To: <1356024359-13039-1-git-send-email-johannes@sipsolutions.net> (sfid-20121220_182542_779409_876F1AAD)
References: <1356024359-13039-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121220_182542_779409_876F1AAD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 18:25 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some AP code ended up in mlme.c as ap.c didn't
> exist when it was written, move it now.

Applied.

johannes

