Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3LPPFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:05:55 -0500
Message-ID: <1387206348.2057.20.camel@jlt4.sipsolutions.net> (sfid-20131216_160604_657923_C98C1198)
Subject: Re: [PATCH v3 3/3] nl80211: add VHT support for set_bitrate_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Mon, 16 Dec 2013 16:05:48 +0100
In-Reply-To: <1386272578-3540-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_204314_402741_BF24BF6A)
References: <1386272578-3540-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131205_204314_402741_BF24BF6A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 20:42 +0100, Janusz Dziedzic wrote:
> Add VHT MCS/NSS set support for nl80211_set_tx_bitrate_mask().
> This should be used mainly for test purpose, to check
> different MCS/NSS VHT combinations.

Applied.

johannes

