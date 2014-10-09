Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57189 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaJIJc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:32:59 -0400
Message-ID: <1412847177.1828.33.camel@jlt4.sipsolutions.net> (sfid-20141009_113304_295310_89DD88AA)
Subject: Re: [PATCH] cfg80211: set the rates mask in connection probes over
 specified freq
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 09 Oct 2014 11:32:57 +0200
In-Reply-To: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com> (sfid-20141007_114239_842820_22582381)
References: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20141007_114239_842820_22582381)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-07 at 11:42 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> ATM, specifying the frequency when connecting sends a void 'supported
> rates' EID.

Seems like this should be a stable fix?

johannes

