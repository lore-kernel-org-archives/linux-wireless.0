Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2JOMwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 08:52:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TNk9d-0001Kd-JZ
	for linux-wireless@vger.kernel.org; Mon, 15 Oct 2012 14:52:21 +0200
Message-ID: <1350305572.27801.7.camel@jlt4.sipsolutions.net> (sfid-20121015_145224_947954_8AA825DB)
Subject: Re: [PATCH] mac80211: remove some unused code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 15 Oct 2012 14:52:52 +0200
In-Reply-To: <1349018165-22826-1-git-send-email-johannes@sipsolutions.net> (sfid-20120930_171534_971256_CC4F28E8)
References: <1349018165-22826-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120930_171534_971256_CC4F28E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 17:16 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are a number of unused variables that gcc
> pointed out (when building with W=1) as well as
> some conditions that can never be true due to
> the datatypes used: unsigned values can't be
> less than zero. Remove this code.

Applied.

johannes

