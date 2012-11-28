Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2K1MXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:23:55 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TdggD-0006Yz-DB
	for linux-wireless@vger.kernel.org; Wed, 28 Nov 2012 13:23:53 +0100
Message-ID: <1354105459.9345.1.camel@jlt4.sipsolutions.net> (sfid-20121128_132358_092009_5B4CF970)
Subject: Re: [PATCH 0/3] mac80211: VHT managed mode & radiotap support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 13:24:19 +0100
In-Reply-To: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net> (sfid-20121126_152456_069102_60283804)
References: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121126_152456_069102_60283804)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 15:25 +0100, Johannes Berg wrote:
> For managed mode, we have to parse the VHT operation IE to
> determine what the channel setting should be, and then take
> into account local capabilities for the channel to use,
> possibly disabling some capabilities due to regulatory.
> 
> Also add some radiotap support so we differentiate VHT from
> other (HT or legacy) frames.

Applied, with a few whitespace changes.

johannes

