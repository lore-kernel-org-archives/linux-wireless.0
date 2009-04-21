Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:33289 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZDUKaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 06:30:18 -0400
Received: by bwz7 with SMTP id 7so1679398bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 03:30:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090420135940.GB3369@tuxdriver.com>
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com>
	 <200904182318.56512.IvDoorn@gmail.com>
	 <20090420135940.GB3369@tuxdriver.com>
Date: Tue, 21 Apr 2009 12:30:16 +0200
Message-ID: <a32f33a40904210330w33a6cea6idf1756428e7560c7@mail.gmail.com> (sfid-20090421_123025_079499_4DE57531)
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg KH <greg@kroah.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2009 at 3:59 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, Apr 18, 2009 at 11:18:56PM +0200, Ivo van Doorn wrote:
>> Hi,
>>
>> > > I hope rt2800pci/usb to be included *ASAP*, because rt2800usb su=
pports
>> > > more than 1oo USB devices and rt2800pci is included in a lot of
>> > > laptops(ask Torvalds [1] [2])
>> > >
>> > > [1] http://marc.info/?l=3Dlinux-netdev&m=3D121799144422863&w=3D2
>> > > [2] http://marc.info/?l=3Dlinux-kernel&m=3D123187052023831&w=3D2
>> >
>> > That would be great to have in, what's keeping it from happening?
>>
>> In short: A stable workable driver.
>>
>> The rt2800usb driver is pretty far (at least on my testsetup), but
>> still has problems with transmitting frames immediately after
>> association.
>
> I read this as "it works, but some frames are lost immediately after
> association" -- is that right?

It is not "Some frames" it is "All frames" you can't get a DHCP lease,
or use a static IP and try to do anything.

Also 11n APs are not detected at all, which for a 11n client sounds
very problematic.

> FWIW, this sounds good enough to me
> to get it into the mainline kernel. =A0_Please_ submit the rt2800usb
> driver for wireless-testing/linux-next ASAP!

If the above 2 problems aren't critical for merge, then I'll send the
patches as soon as possible.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
