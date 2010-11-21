Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54625 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0KUNDD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 08:03:03 -0500
Date: Sun, 21 Nov 2010 08:02:36 -0500
From: Ted Ts'o <tytso@mit.edu>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
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
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101121130236.GE23423@thunk.org>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
 <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 08:46:11AM -0800, Luis R. Rodriguez wrote:
> > What this provides for is a wonderful leverage for hardware
> > vendors.   If they provide GPL'ed code for their core hardware
> > drivers that link against the Linux 802.11 layer, at one fell
> > swoop they also get Windows 7 and Mac OS X drivers for free!
> 
> Yes, indeed ! That would be ideal indeed, but we'd need then an 802.11
> stack which is also permissive licensed and then make APIs for that
> 802.11 stack to match mac80211's or cfg80211's or bridges between
> then. Because ultimately you will still need some 802.11 stack for
> some OSes that don't have one.

I wonder how much this is true.  Yes, at the moment we still need to
worry about those OS's that don't have one; but how much longer will
hardware vendors need to support Windows XP?  If Linux, Windows 7, and
Mac OS X all have an 802.11 stack, what other OS's do the hardware
vendors need to support?

						- Ted
