Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab3BNRk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:40:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U62nK-0001Xs-TQ
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 18:40:27 +0100
Message-ID: <1360863623.8210.11.camel@jlt4.sipsolutions.net> (sfid-20130214_184032_195834_B911B93E)
Subject: Re:
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 18:40:23 +0100
In-Reply-To: <1360586298-15028-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_133827_344785_291C08B3)
References: <[PATCH 00/14] mac80211: HT/VHT handling>
	 <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130211_133827_344785_291C08B3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 13:38 +0100, Johannes Berg wrote:
> These patches improve/fix HT handling, particularly the bandwidth
> change handling that we were missing entirely and HT capability
> handling (which touches many drivers, unfortunately.)
> 
> This should make the VHT handling compliant with D4.0, I hope.

I did a little bit more testing and applied all.

johannes

