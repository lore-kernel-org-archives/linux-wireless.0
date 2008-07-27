Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:3270 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYG0HoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 03:44:10 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3490047ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 00:44:09 -0700 (PDT)
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Date: Sun, 27 Jul 2008 10:03:31 +0200
Cc: linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	akpm@linux-foundation.org
References: <20080722102159.GA32682@doriath.ww600.siemens.net> <200807221911.35975.IvDoorn@gmail.com> <20080727073725.GA20755@doriath.ww600.siemens.net>
In-Reply-To: <20080727073725.GA20755@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807271003.31610.IvDoorn@gmail.com> (sfid-20080727_094425_405679_F7994F60)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 27 July 2008, Dmitry Baryshkov wrote:
> On Tue, Jul 22, 2008 at 07:11:35PM +0200, Ivo van Doorn wrote:
> > On Tuesday 22 July 2008, Dmitry Baryshkov wrote:
> > > Provide default activate function to set the state of the led
> > > when the led becomes bound to the trigger
> > > 
> > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > > Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > 
> > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> Sorry to bother you, but can I expect these patches to be merged
> before 2.6.27, or should I wait for 2.6.28 window?

Well they are not really bugfixes, but I'll let John decide to which tree
they should be merged.

Ivo
