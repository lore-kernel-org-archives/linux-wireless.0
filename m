Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:39636 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbXGHTRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 15:17:30 -0400
Message-ID: <46913846.9000007@warmcat.com>
Date: Sun, 08 Jul 2007 20:17:26 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org>	 <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de>	 <46910F3F.8010201@warmcat.com>	 <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com>	 <469130E8.1010608@warmcat.com> <9e4733910707081204l490e99fcm6b8780f36ef8b9a8@mail.gmail.com>
In-Reply-To: <9e4733910707081204l490e99fcm6b8780f36ef8b9a8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jon Smirl wrote:

>> It's not quite the same path Jon, I don't use wireshark at all just
>> tcpdump.  Maybe it is zd1211rw-mac80211 -specific.
> 
> I can confirm. My BCM4318 is seeing all the packets.
> My zd1211 is only seeing the directed/broadcast ones.
> My rt2x00 is seeing all the packets.
> 
> All three devices are in the same machine and using the same mac80211
> stack so it must be a driver issue with zd1211.

I can add iwl3945 to "sees all the expected stuff" (after a battle) list
as well.

-Andy
