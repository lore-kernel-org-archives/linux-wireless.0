Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:44255 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362Ab0I0J6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 05:58:30 -0400
Subject: Re: [PATCH 16/25] wl1271: Add support for hardware GEM cipher
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285580995.4043.7.camel@jlt3.sipsolutions.net>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-17-git-send-email-luciano.coelho@nokia.com>
	 <1285578777.4043.6.camel@jlt3.sipsolutions.net>
	 <1285580806.11177.65.camel@wimaxnb.nmp.nokia.com>
	 <1285580995.4043.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 12:58:01 +0300
Message-ID: <1285581481.11177.68.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:49 +0200, ext Johannes Berg wrote:
> On Mon, 2010-09-27 at 12:46 +0300, Juuso Oikarinen wrote:
> 
> > > > +#define WL1271_CIPHER_SUITE_GEM 0x000FACFF
> > > 
> > > NACK, this is a standards-reserved value. Use the correct ID for it or
> > > allocate one within your own OUI if you don't want to admit what this
> > > really is (and by now all readers here will know anyway.)
> > 
> > Well I'm sure many or most know what this patch is about. The choice of
> > value was not intended to hide that.
> > 
> > You're right though, we'll need to change the OUI of the value, unless
> > you can point me to an official value to use.
> 
> Well, ISO/IEC JTC 1 N 9880 says you should use 00-14-72:1.

Heh, yes, my local expert on this just gave me the same value. Thanks.

One new patch coming up!

-Juuso

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


