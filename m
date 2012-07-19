Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv10.sysproserver.de ([78.138.89.124]:38932 "EHLO
	srv10.sysproserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSHZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 03:25:41 -0400
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?Andreas_Br=E4u?= <ab@andi95.de>
In-Reply-To: <CA+XFjiqGXCdMYOnQz95biGYdR65x8dEAZzWnyAoWovEJ1tFQrw@mail.gmail.com>
Date: Thu, 19 Jul 2012 09:18:10 +0200
Cc: Bastian Bittorf <bittorf@bluebottle.com>,
	openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	feint@lists.subsignal.org
Message-Id: <982FBF04-5969-436D-9D3A-A6388C077667@andi95.de> (sfid-20120719_092617_026598_8F793ADD)
References: <1342612598.5006a476022c6@mail.bluebottle.com> <CA+XFjiqGXCdMYOnQz95biGYdR65x8dEAZzWnyAoWovEJ1tFQrw@mail.gmail.com>
To: =?iso-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> 
>> 1) why does a band change (can be seen through minstrel) is a problem?
> 
> Because IIRC b43 doesn't support anything other than 2.4GHz at all.

It's not a change between 2.4 and 5 GHz. 
Wifi stops working if the bitrate changes between 11b (1, 2, 5.5, 11) and 11g (6, 9, 12, 18, 24, 36, 48, 54) rates 

So if we tell the system to only use 11g rates, wifi doesn't stop.

Andi