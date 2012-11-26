Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2KZLrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:47:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tcx9b-0001Zd-Tg
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 12:47:12 +0100
Message-ID: <1353930460.9488.30.camel@jlt4.sipsolutions.net> (sfid-20121126_124715_080078_D722AF37)
Subject: Re: [PATCH] mac80211_hwsim: remove printing scan config
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 12:47:40 +0100
In-Reply-To: <1353447604-16327-1-git-send-email-johannes@sipsolutions.net> (sfid-20121120_223939_351202_C7318DE4)
References: <1353447604-16327-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121120_223939_351202_C7318DE4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 22:40 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The frequencies will be printed when actually
> doing the scan, and the IEs can be captured
> on the hwsim0 monitor.

Applied.

johannes

