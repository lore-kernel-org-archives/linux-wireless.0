Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56107.mail.re3.yahoo.com ([216.252.110.201]:22672 "HELO
	web56107.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753906AbZGVBKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 21:10:17 -0400
Message-ID: <928354.18240.qm@web56107.mail.re3.yahoo.com>
References: <43e72e890907211209p5142047cjf821bc536c012f24@mail.gmail.com>  <20090721210422.GA24285@lst.de> <43e72e890907211424j2c1eecdauf1d8279baec0f6f9@mail.gmail.com>  <20090721214219.GA25392@lst.de> <43e72e890907211703y72ffe8cdv88ba9e3c59d1b76@mail.gmail.com>
Date: Tue, 21 Jul 2009 18:03:36 -0700 (PDT)
From: Purushotham Nayak <nayak_purushotham@yahoo.com>
Subject: Re: AR5523 driver - old Atheros USB
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>
In-Reply-To: <43e72e890907211703y72ffe8cdv88ba9e3c59d1b76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I'm interested in working on this. I just posted to the Linux driver project a few days ago if I could work on the atheros USB devices. Please let me also know the USB device that uses the AR5523.

Thanks,
Purush



----- Original Message ----
From: Luis R. Rodriguez <mcgrof@gmail.com>
To: Christoph Hellwig <hch@lst.de>; linux-wireless <linux-wireless@vger.kernel.org>; linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org; Dan Williams <dcbw@redhat.com>; ath5k-devel@lists.ath5k.org; madwifi-devel <madwifi-devel@lists.sourceforge.net>; Jouni Malinen <j@w1.fi>; ath9k-devel@lists.ath9k.org
Sent: Tuesday, July 21, 2009 8:03:36 PM
Subject: Re: AR5523 driver - old Atheros USB

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
> It's been quite some time.  IIRC it does TX, but can't actually see
> any packets on RX (filter issue or something).

Sorry for the large cross post, just seeing if someone is interested
in working on a wireless driver. The task would be to try to get
AR5523 USB driver up to speed with mac80211 from wireless-testing and
giving it a shot to fix remaining issues?

It seems to have compiled last for 2.6.23.

If you're interested please remove all lists and only leave
linux-wireless on the reply.

  Luis
_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/devel



      
