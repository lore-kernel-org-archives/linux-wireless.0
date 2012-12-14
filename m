Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2LNKhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 05:37:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TjSdb-00062v-0l
	for linux-wireless@vger.kernel.org; Fri, 14 Dec 2012 11:37:03 +0100
Message-ID: <1355481446.9571.9.camel@jlt4.sipsolutions.net> (sfid-20121214_113709_209687_8186C18D)
Subject: Re: [PATCH] mac80211_hwsim: allow testing paged RX
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 14 Dec 2012 11:37:26 +0100
In-Reply-To: <1355137142-21292-1-git-send-email-johannes@sipsolutions.net> (sfid-20121210_115844_109015_C979B5D8)
References: <1355137142-21292-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121210_115844_109015_C979B5D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-10 at 11:59 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Paged RX, i.e. SKBs with (some of) the data in pages instead
> of the SKB header data (skb->data) can behave differently in
> the stack and cause other bugs. To make debugging easier add
> an option to hwsim to test with such SKBs.

Applied.

johannes

