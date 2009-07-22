Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.210.202]:44194 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZGVAD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 20:03:58 -0400
MIME-Version: 1.0
In-Reply-To: <20090721214219.GA25392@lst.de>
References: <43e72e890907211209p5142047cjf821bc536c012f24@mail.gmail.com>
	<20090721210422.GA24285@lst.de> <43e72e890907211424j2c1eecdauf1d8279baec0f6f9@mail.gmail.com>
	<20090721214219.GA25392@lst.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 21 Jul 2009 17:03:36 -0700
Message-ID: <43e72e890907211703y72ffe8cdv88ba9e3c59d1b76@mail.gmail.com>
Subject: Re: AR5523 driver - old Atheros USB
To: Christoph Hellwig <hch@lst.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	devel@driverdev.osuosl.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org,
	madwifi-devel <madwifi-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 21, 2009 at 2:42 PM, Christoph Hellwig<hch@lst.de> wrote:
> On Tue, Jul 21, 2009 at 02:24:36PM -0700, Luis R. Rodriguez wrote:
>> >> Hey Chris, was curious if you still had lying around the driver you
>> >> had worked on for the old Atheros 802.11 USB device. Dan asked about
>> >> it, seems he bought one. We at least now have specs for it and can
>> >> provide them to interested developers. Since Dan brought this device
>> >> up figured I'd check to see if you still had it to see if you still
>> >> had the code and might be willing to let someone try to give a shot at
>> >> finishing it up for inclusion. Perhaps staging?
>> >
>> > The code has been at http://verein.lst.de/~hch/ar5523.tgz.
>>
>> Sweet. How functional is this? Does it TX/RX?
>
> It's been quite some time.  IIRC it does TX, but can't actually see
> any packets on RX (filter issue or something).

Sorry for the large cross post, just seeing if someone is interested
in working on a wireless driver. The task would be to try to get
AR5523 USB driver up to speed with mac80211 from wireless-testing and
giving it a shot to fix remaining issues?

It seems to have compiled last for 2.6.23.

If you're interested please remove all lists and only leave
linux-wireless on the reply.

  Luis
