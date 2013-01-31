Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3AaNGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:06:03 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U0tq6-0000Jh-9G
	for linux-wireless@vger.kernel.org; Thu, 31 Jan 2013 14:06:02 +0100
Message-ID: <1359637586.8415.9.camel@jlt4.sipsolutions.net> (sfid-20130131_140624_055905_6A6D1D69)
Subject: Re: [PATCH] mac80211: remove last_probe_resp from bss
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 31 Jan 2013 14:06:26 +0100
In-Reply-To: <1359495232-32092-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_223340_996761_8B99FD0B)
References: <1359495232-32092-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130129_223340_996761_8B99FD0B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 22:33 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We track this, but never use it, so we can
> just remove it.

Applied.

johannes

