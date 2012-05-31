Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2EaMcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 08:32:15 -0400
Message-ID: <1338467530.9102.4.camel@jlt3.sipsolutions.net> (sfid-20120531_143218_715346_1D42C454)
Subject: Re: Master mode support in iwlagn?
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Florian Fainelli <florian@openwrt.org>,
	Dan Williams <dcbw@redhat.com>
Date: Thu, 31 May 2012 14:32:10 +0200
In-Reply-To: <4FC76389.70600@broadcom.com>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 <5625918.SuzapvkoUg@sylvesterjr.cmi.ua.ac.be>
	 <4FC75DA4.2090909@broadcom.com>
	 <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be> <4FC76389.70600@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 14:26 +0200, Arend van Spriel wrote:
> On 05/31/2012 02:16 PM, Erwin Van de Velde wrote:
> > I have one ethernet connection and want to share that connection over 
> > wireless, preferably in AP mode although I guess ad hoc mode is possible too. 
> > Just not sure if NetworkManager supports that.
> 
> NetworkManager does support ad-hoc, but your hardware need to support
> beacon transmission for that as well. You could consider buying an AP.
> They are not that expensive ;-)

iwlwifi does support IBSS for all devices, just not AP mode.

johannes

