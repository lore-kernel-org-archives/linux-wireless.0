Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49579 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab0JKRq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 13:46:58 -0400
Message-ID: <4CB34D87.9090100@candelatech.com>
Date: Mon, 11 Oct 2010 10:46:47 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	rainbow lum <rainbowlum@gmail.com>
Subject: Re: phyX enumeration conflict
References: <201010082159.59262.chunkeey@googlemail.com>	 <1286698152.3547.4.camel@jlt3.sipsolutions.net>	 <1286698604.3547.7.camel@jlt3.sipsolutions.net>	 <4CB1DE18.9070400@candelatech.com>	 <1286729035.3547.10.camel@jlt3.sipsolutions.net>	 <4CB348B0.3050909@candelatech.com> <1286818499.3634.67.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286818499.3634.67.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 10:34 AM, Johannes Berg wrote:
> On Mon, 2010-10-11 at 10:26 -0700, Ben Greear wrote:
>
>> However, the 'phy0' name doesn't change in
>> /debug/ath5k/[phy-dev]/ link, so it confuses my tools.
>
> If it used /debug/ieee80211/[phy-dev]/ then it'd be renamed
> automatically...

I need to get at specific info in the driver's debugfs dir, however.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

