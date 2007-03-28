Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-c.mailcontrol.com ([168.143.177.190]:36244 "EHLO
	cluster-c.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbXC1KJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 06:09:11 -0400
Received: from rly06c.srv.mailcontrol.com (localhost.localdomain [127.0.0.1])
	by rly06c.srv.mailcontrol.com (MailControl) with ESMTP id l2SA8w0j015627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2007 11:09:06 +0100
Received: from submission.mailcontrol.com (submission.mailcontrol.com [86.111.216.190])
	by rly06c.srv.mailcontrol.com (MailControl) id l2SA80u7013700
	for linux-wireless@vger.kernel.org; Wed, 28 Mar 2007 11:08:00 +0100
Message-ID: <460A3DC6.8030604@csr.com>
Date: Wed, 28 Mar 2007 11:04:54 +0100
From: Mark Powell <Mark.Powell@csr.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: WPA/RSN information in cfg80211?
References: <1175034846.5151.20.camel@johannes.berg>	 <460A3665.5090906@csr.com> <1175075263.5151.31.camel@johannes.berg>
In-Reply-To: <1175075263.5151.31.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2007-03-28 at 10:33 +0100, Mark Powell wrote:
>   
>> We certainly need the individual settings. It is nice that
>> wpa_supplicant generates the IE - it saved me writing the code - but
>> that's just being lazy. We still have to modify the IE anyway to add WMM
>> stuff.
>>     
> Do I read that as "I don't care if we get the IE"?
>   
We can build it into the driver if we have to :)
> Putting the IE there has the advantage that you can easily play with new
> things for cards that use the IE by sticking a few more IEs into the
> attribute. 
I agree. Forming the MLME requests, including the IE, is really the role
of the userland app (the SME in IEEE802.11 speak).
> But it has the disadvantage that cards behave differently if
> you give them contradictory settings. Maybe we need a way to ask a card
> which one it wants.
>   
Is that just a case of garbage-in-garbage-out?

Mark



To access the latest news from CSR copy this link into a web browser:  http://www.csr.com/email_sig.php

To get further information regarding CSR, please visit our Investor Relations page at http://ir.csr.com/csr/about/overview
