Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:19727 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754977AbXGKQhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 12:37:47 -0400
Message-ID: <469506AA.9010703@linux.intel.com>
Date: Wed, 11 Jul 2007 09:34:50 -0700
From: jketreno <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
References: <20070621221603.778432000@sipsolutions.net>	 <20070710153456.471e395e@logostar.upir.cz>	 <1184075439.15565.11.camel@johannes.berg>	 <20070710162912.17899683@logostar.upir.cz> <1184079079.15565.13.camel@johannes.berg>
In-Reply-To: <1184079079.15565.13.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2007-07-10 at 16:29 +0200, Jiri Benc wrote:
> 
>> But even if it can be applied upstream, it doesn't solve anything. Imagine
>> a patch which was merged into wireless-dev before this restructuring and
>> which is not upstream. Merging it upstream would mean taking the patch from
>> wireless-dev git and manually modifying it to fit a new structure. And we
>> have a bunch of such patches which should go to 2.6.24 (yes, I really
>> mean .24). Perhaps I'm lazy, but I'd like to avoid that. It's going to be a
>> lot of unpleasant work even without this...
> 
> Which all goes to say that pushing mac80211 for .22 was too fast.

Definitely not too fast.  

The fact that people are using mac80211 from Linus' kernel tip is *GREAT*.  
We have a lot of users now that can pull Linus' tree and use iwlwifi and 
they no longer have to figure out how to patch a kernel, or pull from 
wireless-dev.

The fact that people are working on making patches against mac80211  is 
exactly what mac80211 needs.  By pushing at least some bits out we now 
have a larger audience testing, contributing, and working on making 
mac80211 better.

James
