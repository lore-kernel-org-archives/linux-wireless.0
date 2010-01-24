Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:33923 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab0AXX1z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 18:27:55 -0500
Message-ID: <4B5CD773.1010107@scram.de>
Date: Mon, 25 Jan 2010 00:27:47 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
References: <1264277460.13250.10.camel@maxim-laptop>	 <1264330613.23766.17.camel@johannes.local> <1264357465.4152.4.camel@maxim-laptop>
In-Reply-To: <1264357465.4152.4.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maxim,

>> On Sat, 2010-01-23 at 22:10 +0200, Maxim Levitsky wrote:
>>> I updated the kernel and lost connection to my WPA2
>>> AP. Strangely the WPA handshake completes, but DHCP not.
>> What did you upgrade to?
> latest -git of wireless-testing

I have the same problem since compat-wireless-2010-01-20 with 
iwl3945. compat-wireless-2010-01-15 works OK. However, as i don't 
use any module parameters, i guess i'm using hw encryption.

Thanks,
Jochen
