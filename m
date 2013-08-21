Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3HUJ7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 05:59:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VC5CL-0008B8-T4
	for linux-wireless@vger.kernel.org; Wed, 21 Aug 2013 11:59:30 +0200
Message-ID: <1377079167.15268.9.camel@jlt4.sipsolutions.net> (sfid-20130821_115934_443205_93898B8B)
Subject: Re: [PATCH] mac80211: add missing channel context release
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 21 Aug 2013 11:59:27 +0200
In-Reply-To: <1377079129-23481-1-git-send-email-johannes@sipsolutions.net> (sfid-20130821_115901_139061_26DC7F82)
References: <1377079129-23481-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130821_115901_139061_26DC7F82)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-21 at 11:58 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> IBSS needs to release the channel context when leaving
> but I evidently missed that. Fix it.
> 
> Change-Id: Iaa87fdd143d5a1a7eac5b0bb63d11dca372a6bb3

Umm, I'll remove that :)

johannes

