Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3HUNEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 09:04:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VC856-0002zK-8b
	for linux-wireless@vger.kernel.org; Wed, 21 Aug 2013 15:04:12 +0200
Message-ID: <1377090249.15268.10.camel@jlt4.sipsolutions.net> (sfid-20130821_150419_139271_1E51E685)
Subject: Re: [PATCH v2 3.11] mac80211: add missing channel context release
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 21 Aug 2013 15:04:09 +0200
In-Reply-To: <1377079496-27797-1-git-send-email-johannes@sipsolutions.net> (sfid-20130821_120502_794203_50AA32F4)
References: <1377079496-27797-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130821_120502_794203_50AA32F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-21 at 12:04 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> IBSS needs to release the channel context when leaving
> but I evidently missed that. Fix it.

Tested & applied.

johannes

