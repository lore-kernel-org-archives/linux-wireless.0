Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3AaNHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:07:02 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U0tr3-0000L6-DP
	for linux-wireless@vger.kernel.org; Thu, 31 Jan 2013 14:07:01 +0100
Message-ID: <1359637645.8415.11.camel@jlt4.sipsolutions.net> (sfid-20130131_140709_598495_DAE4BF0A)
Subject: Re: [PATCH] cfg80211: remove free_priv BSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 31 Jan 2013 14:07:25 +0100
In-Reply-To: <1359495699-32332-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_224135_592532_B8A43956)
References: <1359495699-32332-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130129_224135_592532_B8A43956)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 22:41 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Now that mac80211 no longer uses this API, remove
> it completely. If anyone needs it again, we can
> revert this patch of course, but mac80211 was the
> only user right now.

Applied.

johannes

