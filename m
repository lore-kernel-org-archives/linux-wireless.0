Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25709 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab2GCLN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:13:56 -0400
From: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: cfg80211: add 802.11ad (60gHz band) support
Date: Tue, 03 Jul 2012 14:13:49 +0300
Message-ID: <1999545.IJfeGdk5R9@lx-vladimir> (sfid-20120703_131400_109455_73D28839)
In-Reply-To: <1341313457.5131.3.camel@jlt3.sipsolutions.net>
References: <20120703105342.GA29879@elgon.mountain> <1341313457.5131.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 03, 2012 01:04:17 PM Johannes Berg wrote:
> Thanks Dan!
> 
> Is this one of your non-default tests? I think I ran smatch on this, but
> it might be old. Anyway, I'll commit this fix:
> 
> http://p.sipsolutions.net/a1c40eea7e33541b.txt
> 
> johannes

Yes, exactly!

Was about to mail same patch.

What is the best method to catch such cases?
"make allmodconfig", or is there something better?

Tnanks, Vladimir
