Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45168 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbcF1Lmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 07:42:51 -0400
Message-ID: <1467111077.2493.12.camel@sipsolutions.net> (sfid-20160628_134254_962846_EAC4B14A)
Subject: Re: [patch] mac80211: silence an uninitialize variable warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 28 Jun 2016 12:51:17 +0200
In-Reply-To: <20160627143118.GB19889@mwanda>
References: <20160627143118.GB19889@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-27 at 17:31 +0300, Dan Carpenter wrote:
> We normally return an unitialized value, but no one checks it so it
> doesn't matter.  Anyway, let's silence the static checker warning.
> 

Applied.

johannes
