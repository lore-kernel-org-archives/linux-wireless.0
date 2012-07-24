Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2GXOys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 10:54:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1StgVb-0006Qs-NR
	for linux-wireless@vger.kernel.org; Tue, 24 Jul 2012 16:54:47 +0200
Message-ID: <1343141687.4415.41.camel@jlt3.sipsolutions.net> (sfid-20120724_165452_084849_8D0F3AD5)
Subject: Re: [PATCH] mac80211: fix scan_sdata assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 24 Jul 2012 16:54:47 +0200
In-Reply-To: <1342636893-5230-1-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204133_600747_35A6852F)
References: <1342636893-5230-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120718_204133_600747_35A6852F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-18 at 20:41 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We need to use RCU to assign scan_sdata.

Applied for 3.6.

johannes

