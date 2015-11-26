Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35738 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbbKZJgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 04:36:41 -0500
Message-ID: <1448530595.2167.0.camel@sipsolutions.net> (sfid-20151126_103645_411866_09E9618C)
Subject: Re: [PATCH 2/2]iw: UNSPECIFIED_CHAR_IN_COND : Fix
From: Johannes Berg <johannes@sipsolutions.net>
To: Rahul Jain <rahul.jain@samsung.com>
Cc: linux-wireless@vger.kernel.org,
	Amit Khatri <amit.khatri@samsung.com>
Date: Thu, 26 Nov 2015 10:36:35 +0100
In-Reply-To: <1448529080-710-1-git-send-email-rahul.jain@samsung.com>
References: <1448529080-710-1-git-send-email-rahul.jain@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Err, the other patch I can kinda understand - but this one? What kind
of static checker is giving that warning, and what does it really mean?
please describe in the commit log... actually I'm not sure why I should
apply this at all even, if there's a problem just make the function
prototype "unsigned char"?

johannes
