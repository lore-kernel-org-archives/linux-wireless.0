Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34680 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab2JXN7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 09:59:37 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so658706iea.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 06:59:37 -0700 (PDT)
Message-ID: <5087F444.5020403@lwfinger.net> (sfid-20121024_155942_270514_15657897)
Date: Wed, 24 Oct 2012 08:59:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Franky Lin <frankyl@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Driver for USB device with ID 050d:615a
References: <5087035E.9010609@lwfinger.net> <5087CA82.5070902@broadcom.com>
In-Reply-To: <5087CA82.5070902@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 06:01 AM, Arend van Spriel wrote:
> On 10/23/2012 10:51 PM, Larry Finger wrote:
>> Arend and Franky,
>>
>> I recently purchased a Belkin N600 DB USB dongle on Ebay. I wanted to
>> get the model with a Realtek RTL8192DU chip. Instead I got a version
>> with a Broadcom chip, which lsusb identifies as
>>
>> Bus 001 Device 005: ID 050d:615a Belkin Components F7D4101 / F9L1101
>> 802.11abgn Wireless Adapter [Broadcom BCM4323]
>>
>> I have since acquired a different device with the Realtek chip, thus I
>> could return the Belkin device; however, the cost was minimal and I will
>> keep it if there is a driver for it. Is it a brcmfmac device that is not
>> yet in the device tables, or is it some other sort of unit that may
>> never be supported under Linux?
>
> Hi Larry,
>
> I went digging and this chip requires a different driver model (basically a
> split stack between host and dongle). This model is being abandoned for newer
> chips so we decided not to support it in mainline linux.

Thanks for the info. I will try to return the device.

Larry


