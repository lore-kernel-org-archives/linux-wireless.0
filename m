Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50751 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2JYLyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 07:54:12 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TRM0p-00035t-Ns
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2012 13:54:11 +0200
Message-ID: <1351166088.10421.5.camel@jlt4.sipsolutions.net> (sfid-20121025_135420_205722_80A5E002)
Subject: Re: [PATCH] mac80211: use non-atomic bitmap operation for local
 variable
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 25 Oct 2012 13:54:48 +0200
In-Reply-To: <1351091487-17115-1-git-send-email-johannes@sipsolutions.net> (sfid-20121024_171059_502573_93C73B2D)
References: <1351091487-17115-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121024_171059_502573_93C73B2D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-24 at 17:11 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For a local variable there's no need to use the atomic
> set_bit() operation, use __set_bit() instead.

Applied

johannes

