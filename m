Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38911 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab0JFSvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:51:42 -0400
Message-ID: <4CACC53B.4050608@candelatech.com>
Date: Wed, 06 Oct 2010 11:51:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Any /n NICs that support APs and multiple STAs other than ath9k?
References: <4CACA3D7.90108@candelatech.com>	 <AANLkTimB7=odPK3qTAhFBdzaMFFGVar0kyMrb-p9SgYy@mail.gmail.com> <1286390920.3655.402.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286390920.3655.402.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2010 11:48 AM, Johannes Berg wrote:
> On Wed, 2010-10-06 at 11:45 -0700, Luis R. Rodriguez wrote:
>
>> Your best bet is to test against mac80211_hwsim, that would rule out
>> any hardware. I think Jouni and Johannes have also a way to get the
>> devices to talk to each other. Perhaps some documentation of that on
>> the kernel Documentation/networking/mac80211_hwsim/
>
> You can either use network namespaces, or you can now somehow add local
> routes (Patrick worked on that). But that's only needed if you need to
> test IP connectivity at all between the interfaces, as long as you just
> assoc etc. you don't need that.

Oh, I'm using all of Patrick's stuff, and my application is a traffic
generator, so I have no trouble generating traffic to/from interfaces on
the same system.

That said, we're hitting these problems before we ever try to start
traffic most of the time, so it's not so important.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

