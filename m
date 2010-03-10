Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35852 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab0CJVOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 16:14:24 -0500
Received: by mail-bw0-f209.google.com with SMTP id 1so5394977bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 13:14:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268191776.10669.20.camel@mj>
References: <6c6bb6f91003091723t31972586uba80a0a849f3634@mail.gmail.com>
	<6c6bb6f91003091727p322c5589n117a7d774094b20c@mail.gmail.com>
	<1268191776.10669.20.camel@mj>
From: Alastair McKinley <amckinley03@googlemail.com>
Date: Wed, 10 Mar 2010 21:14:04 +0000
Message-ID: <6c6bb6f91003101314l3cce11a6x50ce8b202757d4ef@mail.gmail.com>
Subject: Re: building the rt2x00 drivers on compat-wireless
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 3:29 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2010-03-10 at 01:27 +0000, Alastair McKinley wrote:
>
>> So my question is, how do you build rt2x00 and friends from
>> compat-wireless, there doesn't seem to be an option in
>> ./scripts/driver-select.
>
> Just compile and install everything in compat-wireless.  If something
> fails to compile, please report.  If some drivers fail symbol
> verification, it's not a problem as long as you don't need those
> drivers.
>
> I checked the current compat-wireless on Linux 2.6.26, and following
> modules have unresolved symbols:
>
> b43.ko
> b43legacy.ko
> b44.ko
> rt2800pci.ko
> rt2800usb.ko
> wl1271.ko
>
> rt2800usb could be your device, but most likely your device is something
> older and shouldn't be affected.
>
> --
> Regards,
> Pavel Roskin
>

Hi Pavel,

I didn't realise the default behaviour was to build everything... whoops.

ath5k and rt73usb on compat-wireless-2.6.33 works fine for me on
2.6.31-20 from ubuntu karmic.

Thanks for your help.

Best regards,

Alastair
