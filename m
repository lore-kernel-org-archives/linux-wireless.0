Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47929 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3LEVrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 16:47:08 -0500
Received: by mail-qa0-f49.google.com with SMTP id ii20so9732qab.15
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 13:47:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A09B5B.70800@schinagl.nl>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 6 Dec 2013 08:46:47 +1100
Message-ID: <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> (sfid-20131205_224723_847733_F9E5C627)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-sunxi@googlegroups.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I watch the linux-sunxi list where we're trying to support a certain
family of ARM chips and the boards they're on with open source,
community maintained kernels. They're at the cheaper end of the
spectrum so they usually end up with chipsets which are bought for
their price point and Android compatibility, not their ease of use by
people doing "generic" Linux.

On Fri, Dec 6, 2013 at 2:27 AM, Olliver Schinagl
<oliver+list@schinagl.nl> wrote:
> On 05-12-13 14:25, Neal Peacock wrote:
>>
>>
>> On Dec 5, 2013 4:02 AM, "Olliver Schinagl" <oliver+list@schinagl.nl
>> <mailto:oliver%2Blist@schinagl.nl>> wrote:
>>  >
>>  > Hey Benn,
>>  >
>>  > it appears as if the bluetooth module requires specific firmware to
>> operate, it's likly the FM module requires it too?
>>  >
>>  > Can you confirm this or wether the firmware for the wifi module also
>> contains the BT and FM firmwares?
>>  >
>> Which WiFi chip is this for?
>
> Wifi is mostly handled by extracting it from the broadcom drivers I belive
> via a script, but BT we are in the dark for.

So, the AMPAK AP6210 Wifi+BT combo device contains one of:
1. BCM43362 / BCM20710
2. BCM4330 / BCM40183
3. BCM4329 / BCM40181

Depending on who you talk to. I can only find one reference for
options #1 and #3, so I suspect it's the BCM4330 based chipset,
however I don't have one of these I can crack open so I'm not sure.

Firstly, are there any plans to support the BCM43362 chipset with the
brcmfmac driver in the near future?

Secondly, is there an upstream driver for the bluetooth parts of these
chipsets, and if so, do we need firmware and where can we get it from?
If there isn't, are there any plans to add support for them?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
