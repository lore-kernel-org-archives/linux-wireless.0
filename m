Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3AaNGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:06:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U0tqn-0000KW-Gp
	for linux-wireless@vger.kernel.org; Thu, 31 Jan 2013 14:06:45 +0100
Message-ID: <1359637630.8415.10.camel@jlt4.sipsolutions.net> (sfid-20130131_140654_321617_75EEF692)
Subject: Re: [PATCH] mac80211: remove unused mesh data from bss
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 31 Jan 2013 14:07:10 +0100
In-Reply-To: <1359495687-31995-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_224134_787285_2F1E1840)
References: <1359495687-31995-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130129_224134_787285_2F1E1840)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 22:41 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> These pointers/values are never used, remove them.

Applied.

johannes

