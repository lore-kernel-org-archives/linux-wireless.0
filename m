Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:14612 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbZGJQlO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 12:41:14 -0400
Subject: Re: [PATCH] cfg80211: fix wext setting SSID
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247243749.29747.7.camel@johannes.local>
References: <1247243749.29747.7.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 12:41:12 -0400
Message-Id: <1247244072.2877.15.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-10 at 18:35 +0200, Johannes Berg wrote:
> Pavel reported that you can't set the SSID from "foo" to
> "bar". I tried reproducing, but used different values,
> with different lengths, and thus never saw the obvious
> problem.
> 
> Reported-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Pavel Roskin <proski@gnu.org>

> *sigh*
> tons of stupid mistakes

Two mistakes less.  Thank you!

-- 
Regards,
Pavel Roskin
