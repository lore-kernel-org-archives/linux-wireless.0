Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57001 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1AYH5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 02:57:39 -0500
Received: by qyj19 with SMTP id 19so4163654qyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 23:57:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D0A1DD6.8050500@lwfinger.net>
References: <955019.64728.qm@web56808.mail.re3.yahoo.com>
	<4D0A1DD6.8050500@lwfinger.net>
Date: Tue, 25 Jan 2011 02:57:39 -0500
Message-ID: <AANLkTim5_NGoUK4tWyyaXEWzWSGoE4wYu+fzMf-y7ivA@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 9:10 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/16/2010 07:25 AM, Walter Goldens wrote:
>> Realtek has not yet sent me the code for the USB
>>> devices, but as the chip
>>> and core code is common, it should not be far behind.
>
>> Hey Larry,
>>
>> Whats the status quo for the USB driver?
>
> Realtek is still testing/finishing. They sent me the firmware, which I pushed to
> linux-firmware, thus that part is ready.
>
> As we just got the code for the PCIe version into wireless-testing yesterday, I
> hope that the good news on it will help the USB effort.
>
> Larry

Any word on a mac80211-based driver for the RTL8191SE?  PCIe,
vendor/device is 10ec:8172 (comes standard in a lot of new Toshiba
laptops).  The RTL8191SE and RTL8192SE use the same driver and
firmware from Realtek.  That driver from Realtek is sort of similar to
Realtek's RTL8192CE driver, but, functionally, they look different
enough that I really doubt it would just work if I added the
vendor/device pair and got the rtl8192ce driver to load the right
firmware for the RTL8192SE.

-Brian
