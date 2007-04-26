Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:53163 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031346AbXDZRPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 13:15:25 -0400
Date: Thu, 26 Apr 2007 10:15:17 -0700
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/9] wext: reduce inline abuse
Message-ID: <20070426171517.GA22667@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070424180732.371620000@sipsolutions.net> <20070424180849.651555000@sipsolutions.net> <20070426165032.GB22576@bougret.hpl.hp.com> <200704261903.27932.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200704261903.27932.mb@bu3sch.de>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2007 at 07:03:27PM +0200, Michael Buesch wrote:
> 
> Sure, other people have different opinions on that, but I think
> with my approach we get smallest code with good speed.

	Try with gcc-3.3 if you don't trust me. Your patch will
produce bigger and slower code. Thanks.

	Jean
