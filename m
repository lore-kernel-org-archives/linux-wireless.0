Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXNrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:47:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ur77M-0005zq-Kh
	for linux-wireless@vger.kernel.org; Mon, 24 Jun 2013 15:47:40 +0200
Message-ID: <1372081658.8439.3.camel@jlt4.sipsolutions.net> (sfid-20130624_154744_033385_1F082AE3)
Subject: Re: [PATCH] nl80211: use small state buffer for wiphy_dump
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 24 Jun 2013 15:47:38 +0200
In-Reply-To: <1371632422-21760-1-git-send-email-johannes@sipsolutions.net> (sfid-20130619_110039_742827_520A4B7B)
References: <1371632422-21760-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130619_110039_742827_520A4B7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 11:00 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Avoid parsing the original dump message again and again by
> allocating a small state struct that is used by the functions
> involved in the dump, storing this struct in cb->args[0].
> This reduces the memory allocation size as well.

Applied.

johannes

