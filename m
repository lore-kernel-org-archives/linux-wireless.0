Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3ABKus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 05:50:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqLuJ-0004E0-QE
	for linux-wireless@vger.kernel.org; Wed, 02 Jan 2013 11:50:47 +0100
Message-ID: <1357123873.9839.2.camel@jlt4.sipsolutions.net> (sfid-20130102_115051_077307_26FB4E91)
Subject: Re: [PATCH] wireless: use __packed in ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 11:51:13 +0100
In-Reply-To: <1356693291-12102-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_121443_613309_3CAAEB7D)
References: <1356693291-12102-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121228_121443_613309_3CAAEB7D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-28 at 12:14 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Use __packed instead of __attribute__((packed)).

Applied.

johannes

