Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53099 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab0FDPAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 11:00:54 -0400
Message-ID: <4C09151C.7040509@openwrt.org>
Date: Fri, 04 Jun 2010 17:00:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Roberto Riggio <roberto.riggio@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Strange ACK Behaviour with ath9k
References: <4BEC2318.5050701@create-net.org> <AANLkTimnzAJd9Y02m8OBVLHphL5pbFw56M2LfB1L5oKz@mail.gmail.com> <4BEE684F.2070707@create-net.org> <loom.20100604T153747-904@post.gmane.org>
In-Reply-To: <loom.20100604T153747-904@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-04 3:59 PM, Roberto Riggio wrote:
> 
>> On 05/14/2010 01:15 AM, Björn Smedman wrote:
>> > Hi Roberto,
>> >
>> > When I've seen this it has been caused by a mismatch between the
>> > addresses in the injected frame and that configured in the hardware.
>> > The transmitting radio doesn't understand it is the intended recipient
>> > of the ack and continues retrying.
> 
> It seems that the problem is related to the ack timeout. The strange thing is 
> that if is use (on the transmitter)
> 
> iw phy phy0 set distance 600
> 
> everything works fine
> 
> however if I use:
> 
> iw phy phy0 set distance 300
> 
> ack are ignored. 
Are you using 2.4 or 5 GHz?

- Felix
