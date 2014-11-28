Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47312 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbaK1GgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 01:36:17 -0500
Message-ID: <1417156566.2144.46.camel@coelho.fi> (sfid-20141128_073621_445448_97899A8F)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 08:36:06 +0200
In-Reply-To: <547797A2.9060406@broadcom.com>
References: <1417122413-2935-1-git-send-email-luca@coelho.fi>
	 <1417122413-2935-2-git-send-email-luca@coelho.fi>
	 <547797A2.9060406@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH iw 2/2] add WoWLAN net-detect trigger
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-27 at 22:29 +0100, Arend van Spriel wrote:
> On 11/27/14 22:06, Luca Coelho wrote:
> > From: Luciano Coelho<luciano.coelho@intel.com>
> >
> > Adds a netdetect option to the wowlan triggers that allows the user to
> > request network detection to be started when the device goes to
> > suspend mode.
> 
> So it can start heating up my backpack when I get home. Nice ;-)

Yeah, that's the main benefit of this feature, especially if you
configure the scan interval properly. :D

--
Luca.

