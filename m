Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3JAKRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:17:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VQx1S-0006MZ-TJ
	for linux-wireless@vger.kernel.org; Tue, 01 Oct 2013 12:17:43 +0200
Message-ID: <1380622661.14430.6.camel@jlt4.sipsolutions.net> (sfid-20131001_121746_499396_182132BC)
Subject: Re: [PATCH] mac80211: add explicit IBSS driver operations
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 12:17:41 +0200
In-Reply-To: <1378824794-16689-1-git-send-email-johannes@sipsolutions.net> (sfid-20130910_165323_465723_DECA41F4)
References: <1378824794-16689-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130910_165323_465723_DECA41F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-10 at 16:53 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This can be useful for drivers if they have any failure cases
> when joining an IBSS. Also move setting the queue parameters
> to before this new call, in case the new driver op needs them
> already.

Applied.

johannes

