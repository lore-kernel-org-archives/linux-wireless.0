Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:32792 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbbEPUE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 16:04:57 -0400
Received: by oica37 with SMTP id a37so105037309oic.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 13:04:56 -0700 (PDT)
Message-ID: <5557A2E6.7070406@lwfinger.net> (sfid-20150516_220511_702349_C10A4D9E)
Date: Sat, 16 May 2015 15:04:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alberto Mardegan <mardy@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: tp-link tl-wn8200nd and rtlwifi_new drivers
References: <5557A00E.1090104@users.sourceforge.net>
In-Reply-To: <5557A00E.1090104@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2015 02:52 PM, Alberto Mardegan wrote:
> Hi all!
>    I unfortunately purchased a Tp-Link TL-WN8200ND USB wireless adapter, which
> is not working in Linux (there are several reports of this in this ML already,
> so I won't bother you with another one).
>
> I wanted to test the new rtlwifi_new drivers from
>    https://github.com/lwfinger/rtlwifi_new
> to see if by any chance they could help having this device running. I built then
> and installed them (in Ubuntu 14.04), but I don't know how to make sure that the
> kernel is using the new drivers and not the old ones.
> Is there some hint in the syslog which could tell me whether I'm now using the
> new or the old drivers (for the record, it still doesn't work)?

Please list the USB ID for your device as shown by lsusb.

If you did the 'sudo make install' step without error, then these drivers are 
loaded. All but one of the drivers in rtlwifi_new are for PCI devices, but you 
have a USB model. Thus only driver rtl8192cu might be used by your device.

Larry


