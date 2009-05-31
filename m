Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40065 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZEaMU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 08:20:58 -0400
Received: by bwz22 with SMTP id 22so6965354bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 05:20:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243771847.5248.10.camel@maxim-laptop>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	<20090526222433.GA23972@bombadil.infradead.org> <1243736227.3623.180.camel@debian>
	<43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
	<1243752126.3623.375.camel@debian> <1243771847.5248.10.camel@maxim-laptop>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 31 May 2009 14:20:39 +0200
Message-ID: <69e28c910905310520u3e9c30cfv8f2a9c7eefd9bfcd@mail.gmail.com>
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2009 at 2:10 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Sun, 2009-05-31 at 14:42 +0800, Zhu Yi wrote:
>> On Sun, 2009-05-31 at 14:27 +0800, Luis R. Rodriguez wrote:
>> >
>> > What is the 11n configuration on these devices? Do they have 2
>> > streams? Or are they just 1 stream?
>>
>> It has 1x1, 1x2 and 2x2 on for both 20MHz and 40MHz channels. The
>> firmware HT support is not quite ready at this point. So we haven't done
>> anything 11n related in the driver yet.
>
> I have small question:
>
> This is a fullmac driver, thus if I understand correctly, it behaves on
> the outside more like an Ethernet adapter.
> This will mean that many things possible with normal softmac card won't
> be possible, like sending raw packets, etc...
> (and besides I belive that hardware is more or less the same, but more
> functionality is pushed down to firmware, and more firmware code equals
> to bigger probability of bugs that aren't possible to triage and solve
> easily.
>
> Does this device indicate that intel moves away from softmac devices, or
> this is a device that will mostly be used in some dedicated market
> sector (embedded devices for example)?
>
>
> Best regards,
>        Maxim Levitsky
>

Probably it is fullmac because it is for embedded platforms. That's
also what it being an SDIO device suggests.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
