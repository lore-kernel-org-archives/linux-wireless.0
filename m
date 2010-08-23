Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56330 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752660Ab0HWOlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:41:37 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Mon, 23 Aug 2010 16:41:32 +0200
From: garkein@mailueberfall.de
In-Reply-To: <1282572529.20674.1.camel@wwguy-ubuntu>
Message-ID: <20100823144132.181290@gmx.net>
MIME-Version: 1.0
References: <20100823093615.36500@gmx.net>
 <1282572529.20674.1.camel@wwguy-ubuntu>
Subject: Re: 11h frequency change support in iwlwifi?
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


-------- Original-Nachricht --------
> Datum: Mon, 23 Aug 2010 07:08:49 -0700
> Von: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
> An: "garkein@mailueberfall.de" <garkein@mailueberfall.de>
> CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> Betreff: Re: 11h frequency change support in iwlwifi?

> On Mon, 2010-08-23 at 02:36 -0700, garkein@mailueberfall.de wrote:
> > Hello,
> > 
> > I would like to know whether the client side support for 11h frequency
> change on radar detection is supported in the iwlwifi driver (and/or
> mac80211 if relevant).
> > 
> > I've learned that there is some kind of protocol with which the AP tells
> all clients about a radar related frequency change, which allow the
> clients to seamlessly follow the AP to the new channel.
> > 
> > Apparently this is either not supported or working in Linux/iwlwifi as
> my 5100agn repeatedly just looses the AP if that changes the channel due to
> radar instead of seamlessly following it. (which is bad, no fun if the
> client looses internet ;-))
> > 
> > That why I'm asking whether this currently supported in iwlwifi/Linux
> and if so, what debug flags I should switch on to gain some more information
> on what might be going wrong.
> > 
> > 
> Channel switch is supported in iwlwifi, what version of kernel you are
> using, this feature was introduce no too long ago. Please use
> debug=0x10000003 to debug any issue.
> 
> Thanks
> Wey
> 

I'm using 2.6.35.2 currently. I'll try to make some traces tonight.

Daniel

-- 
GMX DSL SOMMER-SPECIAL: Surf & Phone Flat 16.000 für nur 19,99 ¿/mtl.!*
http://portal.gmx.net/de/go/dsl
