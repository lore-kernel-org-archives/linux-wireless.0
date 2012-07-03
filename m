Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2GCLmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:42:33 -0400
Message-ID: <1341315747.5131.5.camel@jlt3.sipsolutions.net> (sfid-20120703_134236_734360_C3FE4C16)
Subject: Re: cfg80211: add 802.11ad (60gHz band) support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 03 Jul 2012 13:42:27 +0200
In-Reply-To: <20120703113223.GE4519@mwanda>
References: <20120703105342.GA29879@elgon.mountain>
	 <1341313457.5131.3.camel@jlt3.sipsolutions.net>
	 <20120703113223.GE4519@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-03 at 14:32 +0300, Dan Carpenter wrote:

> > Thanks Dan!
> > 
> > Is this one of your non-default tests? I think I ran smatch on this, but
> > it might be old.
> 
> It should be on by default in the latest code.  :)

I'll update anyway, but because of the huge number of warnings in all
the various wireless drives I didn't actually run it, I only ran it on
the mac80211 & cfg80211 code ... oops.

johannes

