Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2JPSR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:17:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TOBho-00052v-GS
	for linux-wireless@vger.kernel.org; Tue, 16 Oct 2012 20:17:28 +0200
Message-ID: <1350411484.10177.5.camel@jlt4.sipsolutions.net> (sfid-20121016_201731_946494_D9817D23)
Subject: Re: [PATCH 3.7] iwlwifi: fix 6000 series channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 16 Oct 2012 20:18:04 +0200
In-Reply-To: <1350411437-2534-1-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201645_346186_A812A5A5)
References: <1350411437-2534-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121016_201645_346186_A812A5A5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-16 at 20:17 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The channel switch command for 6000 series devices
> is larger than the maximum inline command size of
> 320 bytes. The command is therefore refused with a
> warning. Fix this by allocating the command and
> using the NOCOPY mechanism.

I'll also have a pull request for this (tomorrow maybe).

johannes

