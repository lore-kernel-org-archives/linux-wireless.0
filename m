Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283Ab3BNRvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:51:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U62y5-0001jK-7B
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 18:51:33 +0100
Message-ID: <1360864289.8210.12.camel@jlt4.sipsolutions.net> (sfid-20130214_185138_831903_69DC1BF2)
Subject: Re: [PATCH 0/2] VHT (and HT) channel restrictions
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 18:51:29 +0100
In-Reply-To: <1355337296-5815-1-git-send-email-johannes@sipsolutions.net> (sfid-20121212_193437_913434_7A2926BF)
References: <1355337296-5815-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121212_193437_913434_7A2926BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 19:34 +0100, Johannes Berg wrote:
> Right now wpa_supplicant uses the current regulatory domain
> (NL80211_CMD_GET_REG) to see if 40 MHz channels can be used
> for not, but this is inaccurate as it doesn't take into  
> account any possible driver restrictions.    
> 
> Here I'm adding VHT driver restrictions and advertise HT40
> restrictions properly to fix the above issue.

Applied.

johannes

