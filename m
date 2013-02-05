Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab3BENrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 08:47:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2is8-0004PF-TT
	for linux-wireless@vger.kernel.org; Tue, 05 Feb 2013 14:47:41 +0100
Message-ID: <1360072085.8376.7.camel@jlt4.sipsolutions.net> (sfid-20130205_144746_318099_8E21CFE2)
Subject: Re: [PATCH] cfg80211: pass wiphy to cfg80211_ref_bss/put_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 05 Feb 2013 14:48:05 +0100
In-Reply-To: <1359992842-14660-1-git-send-email-johannes@sipsolutions.net> (sfid-20130204_164706_960708_BA11AF9A)
References: <1359992842-14660-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130204_164706_960708_BA11AF9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 16:47 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This prepares for using the spinlock instead of krefs
> which is needed in the next patch to track the refs
> of combined BSSes correctly.

Applied.

johannes

