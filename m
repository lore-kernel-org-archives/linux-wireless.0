Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2K3Mng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:43:36 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TePwN-0002dz-0u
	for linux-wireless@vger.kernel.org; Fri, 30 Nov 2012 13:43:35 +0100
Message-ID: <1354279439.10035.31.camel@jlt4.sipsolutions.net> (sfid-20121130_134338_287275_DB261AB2)
Subject: Re: [PATCH 0/2] mac80211: improve probe request building
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:43:59 +0100
In-Reply-To: <1354191456-29577-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_131720_913143_52969856)
References: <1354191456-29577-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121129_131720_913143_52969856)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 13:17 +0100, Johannes Berg wrote:
> One patch to make it safer and one to remove the temporary
> allocation.

both applied.

johannes

