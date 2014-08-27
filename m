Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60145 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbaH0Hig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 03:38:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by gateway2.nyi.internal (Postfix) with ESMTP id BAAFA20809
	for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2014 03:38:35 -0400 (EDT)
Message-ID: <1409125114.11976.14.camel@localhost> (sfid-20140827_093856_416669_0D037FD9)
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 27 Aug 2014 09:38:34 +0200
In-Reply-To: <1408642331.4388.2.camel@jlt4.sipsolutions.net>
References: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140821_192515_304437_37E734D5) <1408642331.4388.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Do, 2014-08-21 at 19:32 +0200, Johannes Berg wrote:
> On Thu, 2014-08-21 at 19:22 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > RFC 1122 says that unicast packets encapsulated in broadcast
> > link-layer packets should be dropped. Implement that, but also
> > extend it to link-layer multicast packets.
> 
> I cannot find anything equivalent in the IPv6 RFCs - anyone more
> familiar with that who could help check for that?
> 
> And if it's *not* in the IPv6 RFCs, how should we implement this?

I haven't found anything, too. Should I bring this up with IETF?

Bye,
Hannes


