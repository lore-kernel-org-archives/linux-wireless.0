Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.newportit.com ([74.50.55.245]:60113 "EHLO wapdot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab3GJF4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 01:56:49 -0400
Message-ID: <51DCF7A0.5000301@newportit.com> (sfid-20130710_075652_879903_4E6C38D8)
Date: Tue, 09 Jul 2013 22:56:48 -0700
From: Steve Freitas <steve@newportit.com>
MIME-Version: 1.0
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Ilw] Re: Slow throughput on Ultimate-N 6300
References: <51BBF4F1.1050301@newportit.com> <51DCDD54.9090100@newportit.com> <0BA3FCBA62E2DC44AF3030971E174FB3019FFDDF@HASMSX103.ger.corp.intel.com> <51DCF4BF.5010900@newportit.com> <0BA3FCBA62E2DC44AF3030971E174FB3019FFE28@HASMSX103.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3019FFE28@HASMSX103.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wonderful, thank you for the tips. I'll wade back into it tomorrow or 
the next day and let you know what I find.

Thank you,

Steve

On 07/09/13 22:55, Grumbach, Emmanuel wrote:
>> Emmanuel,
>>
>> Thank you for your quick response!
>>
>> It is a regression. I regularly had 300 Mbps speeds on this very access point,
>> but it was years ago, in the 2.6 kernel series. However, I believe, from
>> extensive online searches, that Intel has disabled the N functionality in the
>> firmware on Linux, ostensibly until they (you? :-)
>> ) can fix whatever problem they were seeing. With the demise of the Intel
>> Linux Wireless bug tracker, though, public tracking of the bug has been
>> impossible. There are now-dead links to the defunct bug tracker over this
>> very issue.
>>
> 11n hasn't been disabled in firmware, but rather in driver.
> There is a bug we know about the "fail to flush tx fifo" thing that people reports (through mailing list or bugzilla of RedHat).
> Can you please send the output of the kerne log (dmesg)?
>
>> Sadly I only get 2 MByte/s on N, and under 1 MByte/s G.
>>
>> I have not tried another access point in ages. Tired of replacing fried Netgears
>> and Dlinks and Belkins, I've converted all my friends and families to Apple's
>> access points. I'll try to locate something else and see how it goes.
> No need to. If you say that it worked, then it should still work. The issue I was thinking is the way they use some fancy feature of WiFi that no one implements (besides the wifi module of their devices of course).
> Also, can you please try different firmwares from http://wireless.kernel.org/en/users/Drivers/iwlwifi#Download ?
> I wonder if newer firmware has made things worse. You may want to try older firmware.
> To do so, open the tarball from that you'll download and copy iwlwifi-*.ucode to /lib/firmware.

