Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52417 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbZHTU2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 16:28:17 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 13:28:19 -0700
Date: Thu, 20 Aug 2009 13:28:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Richard Farina <sidhayn@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"dwmw2@infradead.org" <dwmw2@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] atheros: add ar9170.fw 1-stage firmware
Message-ID: <20090820202817.GB18102@mosca>
References: <1250793627-22396-1-git-send-email-lrodriguez@atheros.com>
 <4A8DAD1D.7090608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A8DAD1D.7090608@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2009 at 01:07:57PM -0700, Richard Farina wrote:
> Luis R. Rodriguez wrote:
> > This adds support for ar9170 for using a 1-stage firmware.
> > This means only 1 firmware file is required. AVM Fritz
> > devices require this.
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >
> > Here is a resend, noticed today this wasn't yet in the tree.
> >
> >
> Last I tested this firmware it didn't seem to function nearly as well as
> the 2 stage firmware, and if present, the 1 stage overrides the 2
> stage. 

Can you be more specific than that?

> Is this an improved version? 

No, it is the same firmware.

> Does this work properly in your testing?

Works for me, and is also required for usage of AVM Fritz devices.

  Luis
