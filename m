Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59976 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLDBh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 20:37:59 -0500
Received: by mail-ob0-f169.google.com with SMTP id vb8so2087003obc.14
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2014 17:37:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141204012407.GA31191@kroah.com>
References: <CAD-4tLW3cvGrw3MYiLQni7OMJYGa=QJbrk_q9=9P2QuBb1EVFg@mail.gmail.com>
	<CA+55aFw6zo4rTsEEX5uQe+8zeNR87JzmM8T=wYW7jvrHZPjB8A@mail.gmail.com>
	<20141129191601.GA1234@kroah.com>
	<CAD-4tLXYVtKJMWYW6cQ9aCL6rusUx3YpWSHys4xcTRN_dJ+kOA@mail.gmail.com>
	<20141130184615.GA3122@kroah.com>
	<CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com>
	<20141204012407.GA31191@kroah.com>
Date: Thu, 4 Dec 2014 07:07:58 +0530
Message-ID: <CAD-4tLVrOqiUX2V9_VWMBbnFT-qEsO=zQF4qejd_N2H=scb4aw@mail.gmail.com> (sfid-20141204_023803_059157_A0DC0310)
Subject: Re: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi
 kernel module to the linux source tree)
From: Parth Sane <laerdevstudios@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	driverdev-devel@linuxdriverproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'd say I'm midway through with c programming(part of my computer
engineering degree course) and know a decent amount of git. So yes I'm
comfortable writing code.
Also here's the link to an eBay listing for the same hardware.
http://www.ebay.com/itm/like/231051816145?lpid=82&item=231051816145&lgeo=1&vectorid=229466

I think that should do the trick.
Cheers,
-Parth

On 04/12/2014, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Sun, Nov 30, 2014 at 06:55:12PM +0000, Parth Sane wrote:
>> Hi Greg,
>> You can find the source code attached as a tarball. It works and I have
>> tested
>> it myself. You only need to use make and make install for this.
>
> This really looks like a variant of some existing devices, the rt2x00,
> Ralink driver.
>
> I've copied the maintainers of that driver here.
>
> Is anyone working on support for the following devices in the existing
> rt2x00 USB driver:
>
>         {USB_DEVICE(0x148f, 0x6570)}, /* Ralink 6570 */
>         {USB_DEVICE(0x148f, 0x7650)}, /* MT7650 */
>         {USB_DEVICE(0x148f, 0x6370)}, /* Ralink 6370 */
>         {USB_DEVICE(0x148f, 0x7601)}, /* MT 6370 */
>
> thanks,
>
> greg k-h
>
