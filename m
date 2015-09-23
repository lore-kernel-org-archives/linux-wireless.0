Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60493 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbbIWJQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:16:58 -0400
Message-ID: <1442999816.1889.4.camel@sipsolutions.net> (sfid-20150923_111702_513470_4D37795E)
Subject: Re: [PATCH] mac80211: Do not restart scheduled scan if multiple
 scan plans are set
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 23 Sep 2015 11:16:56 +0200
In-Reply-To: <1442839729-25955-1-git-send-email-luca@coelho.fi>
References: <1442839729-25955-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-21 at 15:48 +0300, Luca Coelho wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> If multiple scan plans were set for scheduled scan, do not restart
> scheduled scan on reconfig because it is possible that some scan
> plans were already completed and there is no need to run them all
> over again. Instead, notify userspace that scheduled scan stopped
> so it can configure new scan plans for scheduled scan.
> 
Please also resend this one with the cfg80211 one.

johannes
