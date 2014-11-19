Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40114 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbaKSSFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:05:31 -0500
Message-ID: <1416420328.9374.18.camel@sipsolutions.net> (sfid-20141119_190535_484436_257B05AB)
Subject: Re: [PATCH v3] nl80211: Broadcast CMD_NEW_INTERFACE and
 CMD_DEL_INTERFACE
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:05:28 +0100
In-Reply-To: <1415802405-10002-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20141112_152713_936239_CB135719)
References: <1415802405-10002-1-git-send-email-tomasz.bursztyka@linux.intel.com>
	 (sfid-20141112_152713_936239_CB135719)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-12 at 16:26 +0200, Tomasz Bursztyka wrote:
> Let the other listeners being notified when a new or del interface
> command has been issued, thus reducing later necessary request to be in
> sync with current context.

Applied.

johannes

