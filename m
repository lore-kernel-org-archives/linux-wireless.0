Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42478 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GCLfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:35:05 -0400
Date: Tue, 3 Jul 2012 14:34:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: cfg80211: add 802.11ad (60gHz band) support
Message-ID: <20120703113452.GF4519@mwanda> (sfid-20120703_133510_532517_665FC1CF)
References: <20120703105342.GA29879@elgon.mountain>
 <1341313457.5131.3.camel@jlt3.sipsolutions.net>
 <1999545.IJfeGdk5R9@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1999545.IJfeGdk5R9@lx-vladimir>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 03, 2012 at 02:13:49PM +0300, Vladimir Kondratiev wrote:
> On Tuesday, July 03, 2012 01:04:17 PM Johannes Berg wrote:
> > Thanks Dan!
> > 
> > Is this one of your non-default tests? I think I ran smatch on this, but
> > it might be old. Anyway, I'll commit this fix:
> > 
> > http://p.sipsolutions.net/a1c40eea7e33541b.txt
> > 
> > johannes
> 
> Yes, exactly!
> 
> Was about to mail same patch.
> 
> What is the best method to catch such cases?
> "make allmodconfig", or is there something better?

This was a Smatch warning.

http://smatch.sourceforge.net/

regards,
dan carpenter

