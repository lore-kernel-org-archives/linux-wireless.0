Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3B0IQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 03:16:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UAcBa-0004Zq-2c
	for linux-wireless@vger.kernel.org; Wed, 27 Feb 2013 09:16:22 +0100
Message-ID: <1361952978.8172.0.camel@jlt4.sipsolutions.net> (sfid-20130227_091628_386026_99BFB635)
Subject: Re: [PATCH 3/4] iwlwifi: fix wakeup status query and packet
 reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 27 Feb 2013 09:16:18 +0100
In-Reply-To: <1361914077-18749-3-git-send-email-johannes@sipsolutions.net> (sfid-20130226_222808_680974_2FBF6182)
References: <1361914034.8440.27.camel@jlt4.sipsolutions.net>
	 <1361914077-18749-1-git-send-email-johannes@sipsolutions.net>
	 <1361914077-18749-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130226_222808_680974_2FBF6182)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-26 at 22:27 +0100, Johannes Berg wrote:

> +				if (is_multicast_ether_addr(hdr->addr1)) {

I forgot to include <linux/etherdevice.h> for that, fixing & will resend
the pull request.

johannes

