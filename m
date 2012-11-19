Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:42:32 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TaSYR-0007Wu-Oz
	for linux-wireless@vger.kernel.org; Mon, 19 Nov 2012 15:42:31 +0100
Message-ID: <1353336183.18299.12.camel@jlt4.sipsolutions.net> (sfid-20121119_154235_781174_9D20C52D)
Subject: Re: [PATCH] mac80211: use CMAC_PN_LEN
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 15:43:03 +0100
In-Reply-To: <1352998948-4843-1-git-send-email-johannes@sipsolutions.net> (sfid-20121115_180201_416503_14A2F174)
References: <1352998948-4843-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121115_180201_416503_14A2F174)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-15 at 18:02 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of hardcoding its value (6), use the constant.

Applied.

johannes

