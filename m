Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43519 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1DKNTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 09:19:46 -0400
Received: by ywj3 with SMTP id 3so2146714ywj.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 06:19:45 -0700 (PDT)
Message-ID: <4DA2FFEE.9050808@lwfinger.net>
Date: Mon, 11 Apr 2011 08:19:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Juan Carlos Garza <juancarlosgarza@gmail.com>,
	linux-wireless@vger.kernel.org,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	users@rt2x00.serialmonkey.com
Subject: Re: Firmware for rt2800pci and rt2800usb
References: <4DA2042A.3010301@gmail.com>	 <1302469406.5282.341.camel@localhost> <4DA22545.6050209@gmail.com>	 <4DA2312B.8080303@lwfinger.net> <4DA23594.8090002@gmail.com>	 <4DA2702B.2080305@lwfinger.net>	 <BANLkTinM-iLEOX997VTxG+zK=8aUHXVmQA@mail.gmail.com> <1302520987.5282.568.camel@localhost>
In-Reply-To: <1302520987.5282.568.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2011 06:23 AM, Ben Hutchings wrote:
> On Mon, 2011-04-11 at 13:14 +0200, Juan Carlos Garza wrote:
>> Hi,
>>
>>
>> On Mon, Apr 11, 2011 at 5:06 AM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>> Hi,
>>>
>>> I am in the process of updating the firmware files for rt2800pci and
>>> rt2800usb. If you have one of the devices that use this driver, please test
>>> the firmware file.
>>>
>>
>> Tested rt2870.bin on vid=07b8 pid=3071 in AP mode using HostAPD, up to
>> now, no problems found.
>
> Could people report versions or md5sums rather than just filenames,
> please?

I think we can safely assume that these testing reports are on the files that I 
sent yesterday, but for completeness the md5sums are

75a1da3caa0b1c95e81dfba207f834c6  rt2860.bin
36c944c3138125605d28c0a3a1338be9  rt2870.bin

The version numbers are 34.00 for rt2860.bin and 29.00 for rt2870.bin.

Larry

