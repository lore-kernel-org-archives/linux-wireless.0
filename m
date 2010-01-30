Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53848 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0A3RBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 12:01:44 -0500
Message-ID: <4B6465F4.1080901@openwrt.org>
Date: Sat, 30 Jan 2010 18:01:40 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Greg Oliver <oliver.greg@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Multiple SSID on same phy
References: <20100129122718.73a6c877@nehalam>	 <1264866128.3546.185.camel@johannes.local>	 <51058d551001300751r4a509e90i521c946dfe9dec4@mail.gmail.com>	 <1264867217.3546.186.camel@johannes.local>	 <51058d551001300814y66d1d589uae15fa50086593b8@mail.gmail.com>	 <1264868231.3546.188.camel@johannes.local>	 <51058d551001300822p7ab564e4jedd6faad380dabc@mail.gmail.com> <1264868803.3546.189.camel@johannes.local>
In-Reply-To: <1264868803.3546.189.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-30 5:26 PM, Johannes Berg wrote:
> On Sat, 2010-01-30 at 10:22 -0600, Greg Oliver wrote:
> 
>> > I don't think I can parse that. In any case, a possible use case would
>> > for instance be a protected company network, along with an unprotected,
>> > internet-only guest network.
>> 
>> 
>> Hmmm, I would put the odds at that happening about 100,000:1 (if not more)
>> 
>> Yes, I know it is feasible, but HIGHLY unlikely.
> 
> It's not. openwrt for example has that as a default configuration. Even
> fonera does.
OpenWrt doesn't even bring up wifi in the default config. It has a one
configured AP mode interface per PHY, which is disabled by default ;)

- Felix
