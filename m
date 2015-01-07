Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35060 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbAGHk6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 02:40:58 -0500
Message-ID: <1420616453.3407.0.camel@sipsolutions.net> (sfid-20150107_084101_077660_6B2E996E)
Subject: Re: [PATCH] mwifiex: do not emit messages while holding spinlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com
Date: Wed, 07 Jan 2015 08:40:53 +0100
In-Reply-To: <1420634425-28306-1-git-send-email-patila@marvell.com> (sfid-20150107_081059_683326_970C28B9)
References: <1420634425-28306-1-git-send-email-patila@marvell.com>
	 (sfid-20150107_081059_683326_970C28B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 18:10 +0530, Avinash Patil wrote:
> Avoid printing dev_{warn/dbg} messages while holding spinlock.

Err, why? There's normally no particular reason to worry about this, so
explaining that might be good.

johannes

