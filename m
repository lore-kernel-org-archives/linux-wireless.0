Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43536 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab0KUTv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 14:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <20101121172906.GD3703@kroah.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu> <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
 <20101121130236.GE23423@thunk.org> <20101121172906.GD3703@kroah.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 21 Nov 2010 11:51:39 -0800
Message-ID: <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Greg KH <greg@kroah.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	Charles Marker <Charles.Marker@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Don Breslin <Don.Breslin@atheros.com>,
	Doug Dahlby <Doug.Dahlby@atheros.com>,
	Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 21, 2010 at 9:29 AM, Greg KH <greg@kroah.com> wrote:
> On Sun, Nov 21, 2010 at 08:02:36AM -0500, Ted Ts'o wrote:
>> On Thu, Nov 18, 2010 at 08:46:11AM -0800, Luis R. Rodriguez wrote:
>> > > What this provides for is a wonderful leverage for hardware
>> > > vendors. ? If they provide GPL'ed code for their core hardware
>> > > drivers that link against the Linux 802.11 layer, at one fell
>> > > swoop they also get Windows 7 and Mac OS X drivers for free!
>> >
>> > Yes, indeed ! That would be ideal indeed, but we'd need then an 802.11
>> > stack which is also permissive licensed and then make APIs for that
>> > 802.11 stack to match mac80211's or cfg80211's or bridges between
>> > then. Because ultimately you will still need some 802.11 stack for
>> > some OSes that don't have one.
>>
>> I wonder how much this is true.  Yes, at the moment we still need to
>> worry about those OS's that don't have one; but how much longer will
>> hardware vendors need to support Windows XP?  If Linux, Windows 7, and
>> Mac OS X all have an 802.11 stack, what other OS's do the hardware
>> vendors need to support?
>
> After visiting with a number of hardware companies that make wireless
> chips, they mentioned that they still need to support, and they still
> get new design wins for both eCos and vxworks, as well as some even
> more obscure embedded operating systems that their customers use.
>
> So unfortunatly, I don't see the ability for some of these vendors to
> drop their own internal wifi stacks any year soon, if they still wish to
> sell into some very large markets.
>
> sorry,

Right -- which is why ideally I think it'd be nice to have an open
permissive stack people shared. My preference would be to just pick up
what FreeBSD has and stick to it as it would then also take care of
FreeBSD. But companies would have to really want to do this and want
to share code.

  Luis
