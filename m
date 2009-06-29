Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:45204 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZF2Pmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 11:42:52 -0400
Received: by qyk31 with SMTP id 31so4724146qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2009 08:42:55 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 29 Jun 2009 08:42:35 -0700
Message-ID: <43e72e890906290842t634b6ee0q24f806a4f7dfe875@mail.gmail.com>
Subject: Re: GSoC project progress - GeoClue integration
To: Dan Winship <danw@gnome.org>
Cc: k roy <kroykroy@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A bit off topic for linux-wireless but since it is a GSoC project for
it adding it for those interested in following up on this progress.

  Luis

On Mon, Jun 29, 2009 at 7:15 AM, Dan Winship<danw@gnome.org> wrote:
> On 06/25/2009 06:55 PM, k roy wrote:
>> I was able to get the
>> providers Hostip, Plazes, Localnet, Manual working along with Geocoding
>> using Geonames and Yahoo. I havent got Gypsy and Gpsd working because I
>> currently dont have a GPS device. I am still figuring how to get Gsmloc
>> provider as the site is down.
>
> OK, but you don't need to test all of the providers; your code will
> generally just be working with the master provider, so as long as at
> least one of the other providers works for you, you should be good.
> (Although if you can find someone to borrow a GPS device from, it might
> be nice to test using that, since that will give you much finer detail
> than the other providers...)
>
>> I plan to work on creating a Master
>> provider and a UI for the Manual provider in 1-2 days.
>
> The author of libchamplain started working on a UI for the manual provider:
>
>  http://blog.pierlux.com/2009/06/08/introducing-geoclue-properties/en/
>
> You might want to use that as a starting point, or you might want to
> just ignore that and write your own. I haven't tried it out at all.
>
>> I am planning to work on gnome-clock and
>> empathy first because some work regarding Geoclue integration has
>> already been done on these two.
>
> I think empathy may be pretty much "done" at this point; the bug you had
> CC:ed me on before has been closed now. I can definitely answer
> questions about the clock stuff though.
>
> -- Dan
>
