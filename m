Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:37542 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYG0Hh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 03:37:56 -0400
Received: by py-out-1112.google.com with SMTP id p76so2994877pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 00:37:55 -0700 (PDT)
Date: Sun, 27 Jul 2008 11:37:25 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Message-ID: <20080727073725.GA20755@doriath.ww600.siemens.net> (sfid-20080727_093847_298117_84E36F93)
References: <20080722102159.GA32682@doriath.ww600.siemens.net> <200807221911.35975.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807221911.35975.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 22, 2008 at 07:11:35PM +0200, Ivo van Doorn wrote:
> On Tuesday 22 July 2008, Dmitry Baryshkov wrote:
> > Provide default activate function to set the state of the led
> > when the led becomes bound to the trigger
> > 
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Sorry to bother you, but can I expect these patches to be merged
before 2.6.27, or should I wait for 2.6.28 window?

-- 
With best wishes
Dmitry

