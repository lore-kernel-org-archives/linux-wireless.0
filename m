Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:55028 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab0DFTw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 15:52:29 -0400
Message-ID: <4BBB90F6.8060406@gmail.com>
Date: Tue, 06 Apr 2010 21:52:22 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] rt2x00: Powersave fixes.
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com> <20100406193409.GA3017@tuxdriver.com>
In-Reply-To: <20100406193409.GA3017@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/10 21:34, John W. Linville wrote:
> On Tue, Mar 30, 2010 at 11:50:22PM +0200, Gertjan van Wingerde wrote:
>> The following 4 patches fix powersave behavior of rt2x00.
>> The first patch fixes the rt2500usb powersave issues found lately.
>> The second on enables powersave for rt2500usb again, now it is fixed.
>> The third and fourth are ongoing work to bring the other PCI drivers
>> in a better shape.
>>
>> All patches are against wireless-2.6.
>>
>> The patch series is also available via:
>>
>> 	git://git.gwingerde.nl/rt2x00-2.6.git
>>
>> Gertjan van Wingerde (4):
>>   rt2x00: Disable auto wakeup before waking up device.
>>   rt2x00: Enable powersaving by default again on rt2500usb.
>>   rt2x00: Add wakeup interrupt handler to rt61pci.
>>   rt2x00: Add wakeup interrupt handler to rt2800pci.
> 
> I don't have any objection to these patches, but they don't
> seem appropriate for 2.6.34 to me.  As such, basing them on
> wireless-next-2.6 seems more appropriate.
> 
> Any objection to me applying them for 2.6.35?
> 

You're the boss ;-)

No, no objections from my side. We already disabled powersaving in 2.6.34,
so we should be covered for that release.

Note that patch 2 then won't apply to wireless-next-2.6, as the patch
that disables powersaving is only in wireless-2.6.

How do you want to handle applying patch 2 from the series; how do we
synchronize?

---
Gertjan.
