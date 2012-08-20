Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2HTLwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:52:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T3QXN-0005Vc-T2
	for linux-wireless@vger.kernel.org; Mon, 20 Aug 2012 13:52:54 +0200
Message-ID: <1345463571.4459.18.camel@jlt3.sipsolutions.net> (sfid-20120820_135258_468162_75FF5145)
Subject: Re: [PATCH 0/3] A-MPDU status reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:52:51 +0200
In-Reply-To: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133547_495621_2A4EC38C)
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120731_133547_495621_2A4EC38C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-31 at 13:35 +0200, Johannes Berg wrote:
> We just added A-MPDU status reporting in radiotap, this
> implements it in mac80211 and iwlwifi. The changes will
> be adopted formally next week so I'll merge the patches
> then (into the different trees.)

Applied the wrieless/mac80211 changes.

johannes

