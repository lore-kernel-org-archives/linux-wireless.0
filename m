Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3BUTo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 14:44:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U8c49-0001rS-J6
	for linux-wireless@vger.kernel.org; Thu, 21 Feb 2013 20:44:26 +0100
Message-ID: <1361475862.8327.1.camel@jlt4.sipsolutions.net> (sfid-20130221_204435_283724_C257AE62)
Subject: Re: [PATCH 0/3] nl80211: large wiphy information
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 21 Feb 2013 20:44:22 +0100
In-Reply-To: <1361356586-11496-1-git-send-email-johannes@sipsolutions.net> (sfid-20130220_113636_394783_3A90D952)
References: <1361356586-11496-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130220_113636_394783_3A90D952)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 11:36 +0100, Johannes Berg wrote:
> These are the patches to support large wiphy information and add
> back the information that previously pushed it over the limit.

Applied all, but of course I'm going to have to rebase after the merge
window.

johannes

