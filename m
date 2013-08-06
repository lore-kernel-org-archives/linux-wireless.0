Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3HFJAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:00:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1V6d8L-00025k-Nm
	for linux-wireless@vger.kernel.org; Tue, 06 Aug 2013 11:00:50 +0200
Message-ID: <1375779646.8219.10.camel@jlt4.sipsolutions.net> (sfid-20130806_110056_189091_ACFC016E)
Subject: Re: [PATCH] wireless: make TU conversion macros available
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 06 Aug 2013 11:00:46 +0200
In-Reply-To: <1375362444-7630-1-git-send-email-johannes@sipsolutions.net> (sfid-20130801_150732_308148_78046B0B)
References: <1375362444-7630-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130801_150732_308148_78046B0B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-01 at 15:07 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> A few places in the code (mac80211 and iwlmvm) use the same
> TU_TO_JIFFIES() macro and could use TU_TO_EXP_TIME() that
> mac80211 has. Make these available to everyone and use them.

Applied.

johannes

