Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966477Ab0BZXC0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 18:02:26 -0500
Subject: Re: [PATCH] libertas: add auto auth mode feature
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Bing Zhao <bzhao@marvell.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
In-Reply-To: <1267190482.3868.7.camel@jlt3.sipsolutions.net>
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com>
	 <1267189710.18491.60.camel@violet>
	 <1267190482.3868.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 15:02:18 -0800
Message-ID: <1267225338.14995.8.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-26 at 14:21 +0100, Johannes Berg wrote:
> On Fri, 2010-02-26 at 14:08 +0100, Marcel Holtmann wrote:
> 
> > However from a different point, how can you try open mode first and
> > detect a failure. Isn't this suppose to be the other way around, try
> > shared first and then fall back to open?
> 
> No, why? If open doesn't get rejected, it should be ok to use.

Unless the AP filters by MAC address; some don't reject open auth in
this case they just accept the device.  I too was under the impression
that it was shared first, open second.  Since shared is much more likely
to get rejected.

Dan


