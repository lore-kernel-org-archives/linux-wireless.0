Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41298 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0CaFuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 01:50:40 -0400
Subject: Re: [PATCH] iw: Add support for connection quality monitor
 configuation
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1270013815.4710.1.camel@jlt3.sipsolutions.net>
References: <1269582379-10253-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269583649.4581.4.camel@jlt3.sipsolutions.net>
	 <1269584079.10120.889.camel@wimaxnb.nmp.nokia.com>
	 <1269584501.4581.5.camel@jlt3.sipsolutions.net>
	 <1270011208.10120.906.camel@wimaxnb.nmp.nokia.com>
	 <1270013023.4710.0.camel@jlt3.sipsolutions.net>
	 <1270013069.10120.907.camel@wimaxnb.nmp.nokia.com>
	 <1270013815.4710.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 08:45:43 +0300
Message-ID: <1270014343.10120.911.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-31 at 07:36 +0200, ext Johannes Berg wrote:
> On Wed, 2010-03-31 at 08:24 +0300, Juuso Oikarinen wrote:
> > On Wed, 2010-03-31 at 07:23 +0200, ext Johannes Berg wrote:
> > > On Wed, 2010-03-31 at 07:53 +0300, Juuso Oikarinen wrote:
> > > 
> > > > > Hmm, yes, maybe. In that case you'd want leaving them out meaning no
> > > > > change I guess. I'll give it another thought, but now I need to get
> > > > > sleep and you won't hear from me again until I'm home on like Sunday :)
> > > > 
> > > > Have you reached any conclusions on this matter? To get this support
> > > > into iw would help my work greatly ;)
> > > 
> > > Sorry. Let's just leave it this way, the no change thing convinced me I
> > > think :) I'll go apply your patch.
> > 
> > Thanks!
> 
> There were a few bugs in it, I've pushed the patch out now, please check
> what I changed.
> 

Damn, you have a keen eye for these :) The fixes appear OK. In fact, I
could swear I had already fixed that U8 thing, but apparently I had
not ;)

-Juuso

> johannes
> 


