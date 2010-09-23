Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46110 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab0IWXFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 19:05:21 -0400
Message-ID: <4C9BDD2C.1090806@candelatech.com>
Date: Thu, 23 Sep 2010 16:05:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Patch to get iw building on Fedora 8
References: <4C98DFB6.10902@candelatech.com> <1285090085.12764.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285090085.12764.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice that you added some code to try to get this working:

#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif


However, it still will not build for me on Fedora 8.  In case I'm doing something
else strange..were you able to build it on FC8 by any chance?

I can easily carry the fix in my own tree, but thought
you might want to know...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

