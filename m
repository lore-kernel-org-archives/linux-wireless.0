Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:33776 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbXHFIZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 04:25:35 -0400
Message-ID: <46B6DAFC.7020301@warmcat.com>
Date: Mon, 06 Aug 2007 09:25:32 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 driver interface semantics
References: <46B27729.5030406@gentoo.org>	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com>	 <1186134894.4647.24.camel@johannes.berg>  <46B3032C.5040306@warmcat.com>	 <1186137166.4647.34.camel@johannes.berg>  <46B304FF.3000305@warmcat.com>	 <1186137715.4647.36.camel@johannes.berg>  <46B30828.3000507@warmcat.com> <1186382658.21957.45.camel@johannes.berg>
In-Reply-To: <1186382658.21957.45.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Fri, 2007-08-03 at 11:49 +0100, Andy Green wrote:
> 
>> ''Because if you have both a hard monitor and a regular interface
>> (monitor_during_oper allowed) then we will never check the CRC on frames
>> that enter the networking path and can get corrupted TCP packets in etc.''
>>
>> If the rest of the networking stack didn't trust the packet anyway and
>> confirms the IP-level checksum, then it can make its own opinion about
>> the packet.
> 
> Maybe it helps if I add that the FCS covers more of the packet than the
> IP checksum; hence, if the FCS fails due to a bit in the area the IP
> checksum does not cover we will not ACK the packet and get a
> retransmission, but the IP checksum will check out as good and we'll
> have a duplicate packet.

Fair enough, thanks for the explanation.

-Andy
