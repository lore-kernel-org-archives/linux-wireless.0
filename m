Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49248 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1IZPU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 11:20:26 -0400
Received: by eya28 with SMTP id 28so3688310eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 08:20:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317048872.2400.4.camel@wwguy-ubuntu>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	<CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	<1317048872.2400.4.camel@wwguy-ubuntu>
Date: Mon, 26 Sep 2011 17:20:25 +0200
Message-ID: <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com> (sfid-20110926_172030_002752_79A22795)
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
From: Henrik Friedrichsen <hrkfdn@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Wey,

Sure! Here's the information you asked for:

On Mon, Sep 26, 2011 at 4:54 PM, wwguy <wey-yi.w.guy@intel.com> wrote:
> Hi Henrik,
>
> On Mon, 2011-09-26 at 07:07 -0700, Henrik Friedrichsen wrote:
>> One more thing I have noticed:
>>
>> This message is only being printed when I connect to the AP, that I
>> have problems with:
>>
>> Sep 26 07:05:03 dharma kernel: [ 2213.379252] iwlagn 0000:03:00.0: Tx
>> aggregation enabled on ra = xx:xx:xx:xx:xx:xx tid = 0
>>
> this message telling us "11n/aggregation" is started; so looks like the
> problem is aggregation related.
I see. Well only after that has been printed, I can surf the internet.
It takes a few seconds for that message to appear (after DHCP info
retrieval).
>
>> On the APs that work fine, it DOES NOT get printed.
>
> I don't see anything special in the dmesg log you send, could you
> provide us more information?
>
> 1. AP brand and model
AVM Fritz!Box Fon WLAN 7390
> 2. channel band and number
It happens in the 2,4GHz and 5GHz frequencies, no matter what channel I use.
> 3. firmware version
17.168.5.3 build 42301
> 4. system setup (bluetooth or any other wireless devices on the system?)
It's a Lenovo x220i laptop. It does have a Bluetooth chip, which is,
however, deactived. Other than that there are no other wireless
devices.
> 5. if you can provide us more detail log, it will be great. (loading the
> iwlagn with debug=0x43fff)
Here's a more detailed log connecting to that AP in the 5GHz range:
http://diff.cc/tmp/kernel_iwlagn.log
>
>
> Thanks
> Wey
>> T
>
>

If you need anything else, let me know.
Thanks
Henrik
