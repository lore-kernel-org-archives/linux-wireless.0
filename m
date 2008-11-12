Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60622 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYKLKaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 05:30:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: [RFC PATCH 4/4] net/ieee80211 -> drivers/net/ipw2x00/libipw_* rename
Date: Wed, 12 Nov 2008 11:29:42 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1226440265-21240-3-git-send-email-linville@tuxdriver.com> <20081111232102.GA5827@tuxdriver.com> <646765f40811111927y7e25bca1xb2bdb7e2b4db112a@mail.gmail.com>
In-Reply-To: <646765f40811111927y7e25bca1xb2bdb7e2b4db112a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811121129.43125.mb@bu3sch.de> (sfid-20081112_113019_207095_868F17F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 November 2008 04:27:58 Julian Calaby wrote:
> On Wed, Nov 12, 2008 at 10:21, John W. Linville <linville@tuxdriver.com> wrote:
> > On Tue, Nov 11, 2008 at 11:22:33PM +0100, Michael Buesch wrote:
> >> On Tuesday 11 November 2008 22:51:05 John W. Linville wrote:
> >> > +config LIBIPW
> >> > +   tristate
> >> > +   select WIRELESS_EXT
> >> > +   select CRYPTO
> >> > +   select CRYPTO_ARC4
> >> > +   select CRYPTO_ECB
> >> > +   select CRYPTO_AES
> >> > +   select CRYPTO_MICHAEL_MIC
> >> > +   select CRYPTO_ECB
> >> > +   select CRC32
> >> > +   select LIB80211
> >> > +   select LIB80211_CRYPT_WEP
> >> > +   select LIB80211_CRYPT_TKIP
> >> > +   select LIB80211_CRYPT_CCMP
> >> > +   ---help---
> >> > +   This option enables the hardware independent IEEE 802.11
> >> > +   networking stack.  This component is deprecated in favor of the
> >> > +   mac80211 component.
> >>
> >> Let's remove this helptext, or replace it by something that's actually true. ;)
> >>       ---help---
> >>         This option enables common routines for the IPW2100 and IPW2200 drivers.
> >
> > Yes, good comment.
> 
> Does this option even need to be visible?
> 
> Only the ipw2x00 drivers use it - and they select it - so do we need
> to bother the user with it?

That's how it currently works in the patch.
The help text is only there for the reader of the Kconfig file. It won't
show up in menuconfig or whatever.

-- 
Greetings Michael.
