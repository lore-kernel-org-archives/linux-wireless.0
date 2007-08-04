Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:60035 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbXHDJmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 05:42:03 -0400
Received: by ug-out-1314.google.com with SMTP id j3so530863ugf
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2007 02:42:01 -0700 (PDT)
To: "Luis Correia" <luis.f.correia@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Date: Sat, 4 Aug 2007 11:46:37 +0200
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	linux-usb-devel@lists.sourceforge.net
References: <46B1B0AE.7050205@gmail.com> <46B43415.1000808@gmail.com> <efe7343f0708040134v30b7ffc1mcfc9b61e555897c3@mail.gmail.com>
In-Reply-To: <efe7343f0708040134v30b7ffc1mcfc9b61e555897c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708041146.37667.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 04 August 2007, Luis Correia wrote:
> Well, it may be an hardware error you got on your stick.

Nope, very doubtfully.
When he is using the latest version there would be a big warning
"Not an rt2500usb device" and the driver would halt loading after that.

> That or it is one of those wrongly named sticks which are actually
> rt73... but i don't really know.
> 
> One last test you could do, go to a friend that uses Windoze and see
> if it works as a client and if yes, which driver did it detect, rt73
> or rt2500usb.

Hmm checking if at least it works on windows would be an idea,
but I am really starting to suspect hardware problems...

Ivo
 
> On 8/4/07, dragoran <drago01@gmail.com> wrote:
> > Ivo van Doorn wrote:
> > > On Friday 03 August 2007, dragoran wrote:
> > >
> > >> thats what I am using it for....
> > >>
> > >
> > > I understand, but if you could test the legacy driver
> > > for any other mode to see if at least the hardware is
> > > all right.
> > > Managed and adhoc mode would already give a good
> > > idea about any possible hardware problems.
> > >
> > >
> > while testing the lagacy driver I got this messages:
> > usb 2-2: new high speed USB device using ehci_hcd and address 4
> > usb 2-2: unable to read config index 0 descriptor/start
> > usb 2-2: chopping to 0 config(s)
> > usb 2-2: string descriptor 0 read error: -71
> > usb 2-2: string descriptor 0 read error: -71
> > usb 2-2: string descriptor 0 read error: -71
> > usb 2-2: no configuration chosen from 0 choices
> > and nothing worked....
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 


