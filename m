Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55737 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755902AbXJJVHW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 17:07:22 -0400
Subject: Re: [PATCH] mac80211: Defer setting of RX_FLAG_DECRYPTED.
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <1191960752.4013.60.camel@johannes.berg>
References: <1191767731.8135.5.camel@localhost>
	 <200710071653.53335.mb@bu3sch.de>  <1191769555.8135.8.camel@localhost>
	 (sfid-20071007_160610_867095_94AA695C)  <1191960752.4013.60.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 23:07:18 +0200
Message-Id: <1192050438.12113.5.camel@localhost> (sfid-20071010_220729_058146_F7A57F32)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-09 at 22:12 +0200, Johannes Berg wrote:
> On Sun, 2007-10-07 at 17:05 +0200, Mattias Nissler wrote:
> 
> > The decryption handlers will skip the frame if the RX_FLAG_DECRYPTED
> > flag is set, so the early flag setting introduced by Johannes breaks
> > decryption. To work around this, call the handlers first and then set
> > the flag.
> > 
> > Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> However, the patch is mangled (line-wrapped)

Sorry. Comes from editing patches manually. I see John already took care
of it ;-)

Mattias

