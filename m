Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947150Ab3BHVYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 16:24:39 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U3vQz-00040G-Lr
	for linux-wireless@vger.kernel.org; Fri, 08 Feb 2013 22:24:37 +0100
Message-ID: <1360358674.29851.34.camel@jlt4.sipsolutions.net> (sfid-20130208_222447_611271_CE64C186)
Subject: Re: [RFC 14/14] mac80211: properly track HT/VHT operation changes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 22:24:34 +0100
In-Reply-To: <1360356410.29851.30.camel@jlt4.sipsolutions.net> (sfid-20130208_215343_885648_67AAFD43)
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
	 <1360344344-15742-15-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130208_183812_452599_890EF4AF) <1360356410.29851.30.camel@jlt4.sipsolutions.net>
	 (sfid-20130208_215343_885648_67AAFD43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 21:46 +0100, Johannes Berg wrote:

> This part works. The rate control update is broken though ...

Fixed, I was using "vht_opmode_bandwidth" but that wasn't valid in
HT ... I've renamed it to "max_cur_bandwidth" and also set it properly
in HT now (this affects patch 5)

johannes

