Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab2KZKYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:24:36 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tcvrf-0000Dy-Ge
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 11:24:35 +0100
Message-ID: <1353925503.9488.5.camel@jlt4.sipsolutions.net> (sfid-20121126_112441_474055_2A8851B8)
Subject: Re: [PATCH 0/3] mac80211: some HT fixes/cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:25:03 +0100
In-Reply-To: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_084235_819167_70339120)
References: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121123_084235_819167_70339120)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 08:42 +0100, Johannes Berg wrote:
> While working on VHT support I found a few small issues with
> the HT support, fix these and also rename the DISABLE_11N
> flag to DISABLE_HT to make it less confusing.

Applied all three.

johannes

