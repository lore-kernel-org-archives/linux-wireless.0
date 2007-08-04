Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:26983 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbXHDIe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 04:34:28 -0400
Received: by rv-out-0910.google.com with SMTP id k20so847920rvb
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2007 01:34:27 -0700 (PDT)
Message-ID: <efe7343f0708040134v30b7ffc1mcfc9b61e555897c3@mail.gmail.com>
Date: Sat, 4 Aug 2007 09:34:27 +0100
From: "Luis Correia" <luis.f.correia@gmail.com>
To: dragoran <drago01@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-usb-devel@lists.sourceforge.net
In-Reply-To: <46B43415.1000808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <46B1B0AE.7050205@gmail.com> <200708032015.57569.IvDoorn@gmail.com>
	 <f6ca9fed0708031114v49736b2cxd4525cc4c1650c7e@mail.gmail.com>
	 <200708032031.23966.IvDoorn@gmail.com> <46B43415.1000808@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, it may be an hardware error you got on your stick.

That or it is one of those wrongly named sticks which are actually
rt73... but i don't really know.

One last test you could do, go to a friend that uses Windoze and see
if it works as a client and if yes, which driver did it detect, rt73
or rt2500usb.

Luis

On 8/4/07, dragoran <drago01@gmail.com> wrote:
> Ivo van Doorn wrote:
> > On Friday 03 August 2007, dragoran wrote:
> >
> >> thats what I am using it for....
> >>
> >
> > I understand, but if you could test the legacy driver
> > for any other mode to see if at least the hardware is
> > all right.
> > Managed and adhoc mode would already give a good
> > idea about any possible hardware problems.
> >
> >
> while testing the lagacy driver I got this messages:
> usb 2-2: new high speed USB device using ehci_hcd and address 4
> usb 2-2: unable to read config index 0 descriptor/start
> usb 2-2: chopping to 0 config(s)
> usb 2-2: string descriptor 0 read error: -71
> usb 2-2: string descriptor 0 read error: -71
> usb 2-2: string descriptor 0 read error: -71
> usb 2-2: no configuration chosen from 0 choices
> and nothing worked....
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
