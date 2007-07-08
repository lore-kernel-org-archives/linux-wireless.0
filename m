Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43131 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283AbXGHSqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 14:46:05 -0400
Message-ID: <469130E8.1010608@warmcat.com>
Date: Sun, 08 Jul 2007 19:46:00 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org>	 <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de>	 <46910F3F.8010201@warmcat.com> <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com>
In-Reply-To: <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jon Smirl wrote:
> On 7/8/07, Andy Green <andy@warmcat.com> wrote:
>> I rebooted into the new kernel and did this only
>>
>> # iwconfig wlan0 mode monitor
>> # ifconfig wlan0 up
>> # iwconfig wlan0 channel 6
>> # tcpdump -i wlan0
>>
>> But all I could see were beacons, this is despite I am ssh-d into that
>> box over the same channel 6 network with WPA and should surely be seeing
>> the encrypted packets?
> 
> I have been down the same path, tcpdump shows the encrypted packets,
> but they aren't visible in Wireshark. I could only see directed
> packets and broadcast ones. What fixed for me was rm -rf .wireshark in
> /root.

It's not quite the same path Jon, I don't use wireshark at all just
tcpdump.  Maybe it is zd1211rw-mac80211 -specific.

-Andy

