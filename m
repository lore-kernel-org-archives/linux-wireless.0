Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34342 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZGaVIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:08:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
Date: Fri, 31 Jul 2009 23:08:30 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com> <200907281808.35906.mb@bu3sch.de> <83a869cd0907311404o793c1733p43e936437a923340@mail.gmail.com>
In-Reply-To: <83a869cd0907311404o793c1733p43e936437a923340@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907312308.31066.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 July 2009 23:04:17 gregor kowski wrote:
> Hi Michael,
> 
> On 7/28/09, Michael Buesch <mb@bu3sch.de> wrote:
> >> This add hardware tkip for b43.
> >
> > First of all, I don't really want to support hw tkip on b43.
> > Broadcom removed the support for hw tkip from their drivers. I bet they
> > had a very good reason to do so.
> Did they remove it from the firmware or only the driver ?

I'm not sure about the firmware. But they removed it from the driver.

> > It's mapped to 4, because you removed the old API support.
> > (I'm not sure whether we want to remove that support, yet. Gimme some time
> > on it...)
> >
> Does the old API still useful ?

Well, I'm not sure. Why do we remove it at all? It just avoids one single
if condition in your tkip patch, doesn't it?

> Are there v4 firmware supporting old API ?

Yes

-- 
Greetings, Michael.
