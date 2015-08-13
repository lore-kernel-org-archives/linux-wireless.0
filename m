Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47129 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbbHMJg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 05:36:58 -0400
Message-ID: <1439458616.2114.15.camel@sipsolutions.net> (sfid-20150813_113704_129571_A715C417)
Subject: Re: [patch] mac80211: remove always true condition
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 13 Aug 2015 11:36:56 +0200
In-Reply-To: <20150727081111.GB2937@mwanda>
References: <20150727081111.GB2937@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-07-27 at 11:11 +0300, Dan Carpenter wrote:
> The outside if statement checks that IEEE80211_TX_INTFL_MLME_CONN_TX 
> is
> set so this condition is always true.  Checking twice upsets the 
> static
> checkers.
> 

Yeah, this was left over in some refactoring - thanks, applied.

johannes
