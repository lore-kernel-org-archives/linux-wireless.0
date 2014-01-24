Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34585 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaAXJ0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 04:26:16 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so845220eek.13
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 01:26:15 -0800 (PST)
Date: Fri, 24 Jan 2014 10:26:12 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [README] bug fixes only...
Message-ID: <20140124092612.GB3153@minipsycho.orion> (sfid-20140124_102626_031940_2A50A677)
References: <20140123.162408.681541949851852312.davem@davemloft.net>
 <20140124083927.GA3153@minipsycho.orion>
 <20140124.011800.1437880947731667846.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140124.011800.1437880947731667846.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fri, Jan 24, 2014 at 10:18:00AM CET, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Fri, 24 Jan 2014 09:39:27 +0100
>
>> Fri, Jan 24, 2014 at 01:24:08AM CET, davem@davemloft.net wrote:
>>>
>>>I want to see zero feature and/or cleanup patches submitted at this
>>>time.
>>>
>>>net-next is now frozen and I'm going to let it sit for a day before
>>>I try to merge it to Linus.
>>>
>>>Thanks for your understanding.
>> 
>> Hi Dave.
>> 
>> Please do not forget about the patch named "rtnetlink: remove
>> IFLA_BOND_SLAVE definition" which is currently in patchwork.
>> It would not be good if the definition got from net-next into linus's tree.
>
>I applied it before you wrote this. :-)

Yep, your "applied" message appeared once I sent this :)
