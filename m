Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49943 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZHCX6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 19:58:11 -0400
Subject: Re: [PATCH 000/002] Fix frequent reconnects caused by new
 conection monitor
From: Marcel Holtmann <marcel@holtmann.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249338797.13895.0.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249338797.13895.0.camel@maxim-laptop>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 16:58:05 -0700
Message-Id: <1249343885.3094.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > Hi, here is the updated version of these two patches that fix the
> > $SUBJECT issue.
> > 
> > I attach these (in case mailer mangles them), and reply with patches.
> > 
> > Tested both with low quality signal, and beacon loss.
> > Lack of TX is found, every 30 seconds now, and quite reliable.
> > Lack of beacons, triggers probe like it did every 2 seconds.
> > 
> > 
> > 
> > Best regards,
> > Maxim Levitsky
> 
> Just a question, when to see these in wireless-testing?

patches have been acked and tested by various people. Should be pretty
much safe to apply and they are helping many of us to get back a stable
WiFi connection.

Regards

Marcel


