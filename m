Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:35042 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939Ab0I0KCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 06:02:00 -0400
Subject: Re: [PATCH 16/25] wl1271: Add support for hardware GEM cipher
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285581481.11177.68.camel@wimaxnb.nmp.nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-17-git-send-email-luciano.coelho@nokia.com>
	 <1285578777.4043.6.camel@jlt3.sipsolutions.net>
	 <1285580806.11177.65.camel@wimaxnb.nmp.nokia.com>
	 <1285580995.4043.7.camel@jlt3.sipsolutions.net>
	 <1285581481.11177.68.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 13:01:17 +0300
Message-ID: <1285581677.5768.70.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:58 +0200, Oikarinen Juuso (Nokia-MS/Tampere)
wrote:
> On Mon, 2010-09-27 at 11:49 +0200, ext Johannes Berg wrote:
> > On Mon, 2010-09-27 at 12:46 +0300, Juuso Oikarinen wrote:
> > 
> > > > > +#define WL1271_CIPHER_SUITE_GEM 0x000FACFF
> > > > 
> > > > NACK, this is a standards-reserved value. Use the correct ID for it or
> > > > allocate one within your own OUI if you don't want to admit what this
> > > > really is (and by now all readers here will know anyway.)
> > > 
> > > Well I'm sure many or most know what this patch is about. The choice of
> > > value was not intended to hide that.
> > > 
> > > You're right though, we'll need to change the OUI of the value, unless
> > > you can point me to an official value to use.
> > 
> > Well, ISO/IEC JTC 1 N 9880 says you should use 00-14-72:1.
> 
> Heh, yes, my local expert on this just gave me the same value. Thanks.
> 
> One new patch coming up!

Cool, thanks for fixing this quickly, Juuso.  I'll replace the current
patch with your new one.


-- 
Cheers,
Luca.

