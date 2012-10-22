Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2JVOfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 10:35:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TQJ6H-0007V5-9Z
	for linux-wireless@vger.kernel.org; Mon, 22 Oct 2012 16:35:29 +0200
Message-ID: <1350916563.10166.13.camel@jlt4.sipsolutions.net> (sfid-20121022_163534_006202_753B8D02)
Subject: Re: [PATCH] mac80211: fix WDS channel context test
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 22 Oct 2012 16:36:03 +0200
In-Reply-To: <1350912204-31722-1-git-send-email-johannes@sipsolutions.net> (sfid-20121022_152256_780761_E7E6B293)
References: <1350912204-31722-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121022_152256_780761_E7E6B293)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-22 at 15:23 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> WDS is (currently) not allowed when channel
> contexts are *supported*, not when they're
> *not* supported. Fix the inverted test.
> 
> Reported-by: Ronald <ronald645@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied.

johannes

