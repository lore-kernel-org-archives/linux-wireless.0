Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaAGXMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:12:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W0fpI-0004xh-3q
	for linux-wireless@vger.kernel.org; Wed, 08 Jan 2014 00:12:48 +0100
Message-ID: <1389136365.20626.0.camel@jlt4.sipsolutions.net> (sfid-20140108_001256_034847_D3FC8EE3)
Subject: Re: [PATCH] mac80211: remove channel_change_time
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 08 Jan 2014 00:12:45 +0100
In-Reply-To: <1389043476-6193-1-git-send-email-johannes@sipsolutions.net> (sfid-20140106_222445_458949_E5C4ADFB)
References: <1389043476-6193-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140106_222445_458949_E5C4ADFB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 22:24 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This value is no longer used by mac80211, and practically no
> driver ever set it to a correct value anyway, so remove it.

Applied.

johannes

