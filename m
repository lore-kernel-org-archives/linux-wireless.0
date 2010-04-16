Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4457 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758629Ab0DPVTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:19:08 -0400
Message-ID: <4BC8D44A.2040903@gmail.com>
Date: Fri, 16 Apr 2010 23:19:06 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb: delete Allwin devices
References: <1271413005-2509-1-git-send-email-xose.vazquez@gmail.com> <u2ja32f33a41004160417jfcf1db3bw62d464405fead085@mail.gmail.com> <20100416134326.GD8554@tuxdriver.com>
In-Reply-To: <20100416134326.GD8554@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/10 15:43, John W. Linville wrote:
> On Fri, Apr 16, 2010 at 01:17:07PM +0200, Ivo Van Doorn wrote:
>> On Fri, Apr 16, 2010 at 12:16 PM, Xose Vazquez Perez
>> <xose.vazquez@gmail.com> wrote:
>>> Common sense says:
>>> (0x8516, 0x2070) is RT2070
>>> (0x8516, 0x2770) is RT2770
>>> (0x8516, 0x2870) is RT2870
>>> [...]
>>>
>>> but Allwin doesn't sell USB dongles nor PCI boards, only voip-routers
>>> http://www.allwin.com.tw/eng/modules/tinyd0/content/index.php?id=1
>>
>> But how about the case where the company name is wrong and the ID's are valid?
>> That means we only should update the comment, rather then deleting the ID's.
> 
> Or the case where someone ports Linux to those voip routers...

And finally, these devices are still mentioned in the Ralink windows driver,
so we must assume that they actually exist.

However, the common sense approach may be appropriate, so moving these devices
to the correct section does seem okay.

---
Gertjan.
