Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:57031 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1LRE4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 23:56:50 -0500
Received: by qadb15 with SMTP id b15so2724544qad.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 20:56:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EECBDDC.5070908@lwfinger.net>
References: <CAFU7RzPF7NKRkY70Vp_b55AUeDip+ePxk=zqJ_K=SsXUfse7Jw@mail.gmail.com>
	<4EECBDDC.5070908@lwfinger.net>
Date: Sun, 18 Dec 2011 05:56:48 +0100
Message-ID: <CAFU7RzNmrAWT+ZuZZ3tFsn2GZpUbkZHW1zwG99KGV4ceQdcbkQ@mail.gmail.com> (sfid-20111218_055710_577201_B19A568B)
Subject: Re: wl0084a / wl1271 understanding
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Dec 17, 2011 at 5:05 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/16/2011 10:54 PM, Raffaele Recalcati wrote:
>>
>> I'm an embedded developer and I really want opensource development for
>> wireless, to be sure to maintain it in many kernel versions I will
>> have.
>> I'm not an wifi expert and so I can have done some mistakes here below.
>>
>> wl0084a
>> =============
>> grep -rin wl008 drivers
>> give no result on kernel 3.2-rc6.
>> What is the normal approach to take in account?
>> I have to immediately change the usb wifi dongle due to the lacking of
>> information to develop e proper driver or maybe
>> there is some possibility?
>> Here I can find Logilink drivers
>> http://www.logilink.eu/content/support/download.htm?seticlanguage=en
>> They confirm support for LINUX (kernel 2.6.18 ~ 2.6.33)
>> Looking into drivers files ... yes , they are proprietary.
>
>
> Some of the Logilink devices have Realtek chips. If this is a USB device,
> please post the output of 'lsusb'. If it is PCI, post the output of 'lspci
> -nnv' - we only need the part that describes the wireless device.
>
> Larry
>

Bus 002 Device 004: ID 0bda:8176 Realtek Semiconductor Corp.
