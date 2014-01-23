Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:50383 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWMGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:06:02 -0500
Message-ID: <1390478759.4189.91.camel@porter.coelho.fi> (sfid-20140123_130607_555344_1C8E8443)
Subject: Re: wl12xx force lower bitrate
From: Luca Coelho <luca@coelho.fi>
To: Charles <hobbesc7@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 14:05:59 +0200
In-Reply-To: <CAKKnJbdK1eJJoFZik1SENg1PtnqMsK=B4mEtoausGybKNywSqw@mail.gmail.com>
References: <CAKKnJbdK1eJJoFZik1SENg1PtnqMsK=B4mEtoausGybKNywSqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 14:09 -0500, Charles wrote:
> I'm using the wl12xx-spi driver with a TI wl1271 chipset.  In my
> application, range is more important than throughput, so I want to
> force a lower bitrate (like 802.11b speeds at the fastest.)
> 
> None of the commands for doing this seem to have any effect, however.
> I've tried both iwconfig and iw.
> 
> Is forcing a lower bitrate possible with this driver / firmware / chipset?

Rate control should do this automatically.  If you have good signal
conditions, it will use the highest possible rate.  If things start to
degrade (as if you get further away from the AP), the rate will drop.

--
Luca.

