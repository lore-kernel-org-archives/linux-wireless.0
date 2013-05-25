Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3EYALR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 20:11:17 -0400
Message-ID: <1369440712.8000.11.camel@dcbw.foobar.com> (sfid-20130525_021124_617568_B2114A94)
Subject: Re: Mobile Broadband Interface Model (MBIM) support?
From: Dan Williams <dcbw@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, dcbw@redhat.com,
	"Ismail, Rahman" <abdul.r.ismail@intel.com>,
	"Wallick, Stephanie S" <stephanie.s.wallick@intel.com>
Date: Fri, 24 May 2013 19:11:52 -0500
In-Reply-To: <20130524181051.GB15788@xanatos>
References: <20130524170915.GA15788@xanatos>
	 <20130524181051.GB15788@xanatos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-24 at 11:10 -0700, Sarah Sharp wrote:
> Ccing Dan Williams, since Johannes Berg mentioned on IRC that Dan might
> know the status of MBIM support.

As Bjorn mentioned, libmbim just got a 1.0 release, and ModemManager
0.7.x (git master, basically) has support for MBIM devices via libmbim.
0.7.x will turn into an official 0.8 release Real Soon Now; it's already
built for Fedora 20, though we don't have libmbim capability in F20
quite yet.

Dan

> On Fri, May 24, 2013 at 10:09:15AM -0700, Sarah Sharp wrote:
> > Do we have support for the new extensions for USB communication devices
> > that use the Mobile Broadband Interface Model (MBIM) spec?
> > 
> > http://www.usb.org/developers/devclass_docs/MBIM10Errata1.zip
> > 
> > The spec was released pretty recently, which is why I'm asking on the
> > mailing lists, rather than digging around the kernel tree for a driver.
> > 
> > Sarah Sharp
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


