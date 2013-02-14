Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3BNUAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:00:54 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U64zF-0003rP-6k
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 21:00:53 +0100
Message-ID: <1360872035.8210.15.camel@jlt4.sipsolutions.net> (sfid-20130214_210057_533841_DD640CF9)
Subject: Re: [PATCH] mac80211: stop modifying HT SMPS capability
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 21:00:35 +0100
In-Reply-To: <1360675552-29511-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_142603_624993_5F6F6E47)
References: <1360675552-29511-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130212_142603_624993_5F6F6E47)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 14:25 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of modifying the HT SMPS capability field
> for stations, track the SMPS mode explicitly in a
> new field in the station struct and use it in the
> drivers that care about it. This simplifies the
> code using it.

Applied.

johannes

