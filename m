Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbaDVPWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:22:22 -0400
Message-ID: <1398180129.4211.22.camel@jlt4.sipsolutions.net> (sfid-20140422_172228_281507_D2DD2755)
Subject: Re: [PATCH] cfg80211: reg: track crda request
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Tue, 22 Apr 2014 17:22:09 +0200
In-Reply-To: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140416_125421_106057_5E6A5207)
References: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140416_125421_106057_5E6A5207)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-16 at 12:53 +0200, Janusz Dziedzic wrote:
> Track CRDA request and handle timeout when no answer
> from CRDA. This could happen when crda is not available
> yet (not mounted fs), eg. during OS startup and cfg80211
> built-in to the kernel.
> Before we could stuck when processing last request
> without ability to process current and any further
> regulatory requests.

Hmm, this doesn't apply now on top of the patches Luis sent. Was this
the patch that was meant alternatively?

johannes

