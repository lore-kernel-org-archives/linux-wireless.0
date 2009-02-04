Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:3974 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZBDPsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 10:48:13 -0500
Received: by mu-out-0910.google.com with SMTP id i10so438818mue.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 07:48:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090204144317.GA3845@tuxdriver.com>
References: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com>
	 <200902040917.14343.oliver@neukum.org>
	 <20090204144317.GA3845@tuxdriver.com>
Date: Wed, 4 Feb 2009 17:48:11 +0200
Message-ID: <da94abde0902040748l6194cdd3i7044c839f3110e5a@mail.gmail.com> (sfid-20090204_164818_723348_595C8A33)
Subject: Re: at76_usb development
From: Kalle Valo <kalle.valo@iki.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Oliver Neukum <oliver@neukum.org>,
	Jason Andryuk <jandryuk@gmail.com>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, milan.plzik@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 4, 2009 at 4:43 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Feb 04, 2009 at 09:17:12AM +0100, Oliver Neukum wrote:
>> Am Wednesday 04 February 2009 05:05:04 schrieb Jason Andryuk:
>> > Where should development on at76_usb take place?
>> [..]
>> > I have more or less tracked down an Oops on disconnect with the
>> > wireless-testing version.  Hopefully the time spent has been
>> > worthwhile.
>> >
>> > Let me know,
>>
>> This is an important question. We cannot develop against widely
>> diverging versions. If the driver is changed a lot, development must happen
>> against the kernel version or it should be removed from the kernel.

My plan is that at76_usb is not going to get that much changes. I have
created a new driver at76c50x-usb which is basically at76_usb plus my
mac80211 port. That way users still have a working driver until
mac80211 port has stabilised.

> AFAIK you should be sending patches to Greg against the version in
> drivers/staging.  Kalle may want to be copied.

Yes, please cc also me. I try to keep up-to-date what's happening with
at76-usb so that the same fixes will be fixed in at76c50x-usb as well.

> FWIW, I haven't seen the revised driver that Kalle is developing.
> Hopefully we will see that before too long.

Hopefully I'll send a first version of at76c50-usb soon. Sorry for
taking it so long.

It's nice to see interest for at76_usb, though. I was sure that nobody
uses it anymore.

Kalle
