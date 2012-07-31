Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab2GaLXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:23:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwAYE-0007Bq-6O
	for linux-wireless@vger.kernel.org; Tue, 31 Jul 2012 13:23:46 +0200
Message-ID: <1343733822.4474.0.camel@jlt3.sipsolutions.net> (sfid-20120731_132351_744213_242AC64F)
Subject: Re: [PATCH] mac80211: supress HT/VHT disable if not supported
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 31 Jul 2012 13:23:42 +0200
In-Reply-To: <1343386355-2269-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_125245_307379_8BB99DBA)
References: <1343386355-2269-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120727_125245_307379_8BB99DBA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 12:52 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If HT/VHT isn't supported by us we shouldn't print
> a message that we disabled it, do that only if the
> AP didn't support WMM and we therefore disable it.

Applied.

johannes

