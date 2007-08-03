Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:28225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683AbXHCSL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 14:11:29 -0400
Received: by ug-out-1314.google.com with SMTP id j3so495974ugf
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 11:11:28 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Date: Fri, 3 Aug 2007 20:15:57 +0200
Cc: linux-wireless@vger.kernel.org
References: <46B1B0AE.7050205@gmail.com> <200708032007.45875.IvDoorn@gmail.com> <f6ca9fed0708031105y5e87330fq1518b755a14ab028@mail.gmail.com>
In-Reply-To: <f6ca9fed0708031105y5e87330fq1518b755a14ab028@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708032015.57569.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007, dragoran wrote:
> ok this makes sense.
> is the legacy driver supported by hostapd?

Nope, there is no master mode support in the legacy drivers.

Ivo

> On 8/3/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > On Friday 03 August 2007, dragoran wrote:
> > > no I havn't I will try it tomorrow and tell you if it worked.
> > > but as I said before a earilier version of the driver worked before on
> > > fc6 without any problems.
> >
> > Yes, but I want to rule out hardware problems completely.
> > If legacy still works then there is nothing with the hardware,
> > but indeed a driver problem.
> > If the legacy driver shows the same problem, it might be a hardware problem.
> >
> > Ivo
> >
> 


