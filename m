Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab3KGXhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 18:37:21 -0500
Message-ID: <1383867422.2391.10.camel@dcbw.foobar.com> (sfid-20131108_003734_521532_614D42CB)
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
From: Dan Williams <dcbw@redhat.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Nov 2013 17:37:02 -0600
In-Reply-To: <20131107230215.GF12612@shaftnet.org>
References: <20131107160522.GA12612@shaftnet.org>
	 <527BC04F.2080000@lwfinger.net> <20131107163719.GC12612@shaftnet.org>
	 <20131107175201.GA2002@tuxdriver.com> <20131107185714.GD12612@shaftnet.org>
	 <20131107191122.GD2002@tuxdriver.com> <20131107194641.GE12612@shaftnet.org>
	 <1383863100.2391.5.camel@dcbw.foobar.com>
	 <20131107230215.GF12612@shaftnet.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-07 at 18:02 -0500, Solomon Peachy wrote:
> On Thu, Nov 07, 2013 at 04:25:00PM -0600, Dan Williams wrote:
> > > At this point it's a more modern driver than the ones already in the 
> > > kernel, and I'm willing to maintain it if there's a point to doing so.
> > 
> > What's the delta in device support between prism2_usb and the hostap
> > driver's USB subdriver?  Is there any overlap?
> 
> Given that there never was a hostap_usb, there's no overlap at all.  If 
> you have a prism2.5/3 USB widget, you'll need prism2_usb to make it more 
> than a lousy paperweight.

Sorry, I see now I meant orinico_usb, not hostap...

Dan

> Way back in the day I'd advocated for doing a USB port of hostap rather 
> than mainlining prism2_usb, strictly on a ROI basis, but the boots on 
> the ground chose the latter.  Given that prism2_usb has slowly been 
> improved since then and hostap has largely been ignored, IMO the right 
> thing here is to get it out of staging by taking care of any outstanding 
> problems.
> 
> On a strict feature basis, hostap has the advantage of supporting AP 
> operation and WPA -- For the latter, prism2_usb just needs the cfg80211 
> and crypto layer hooks since it needs to be handled in software anyway.  
> As for AP operation -- Intersil never officially supported AP mode on 
> the USB devices, and while it worked unofficially, it wasn't terribly 
> stable.  The same stabilitiy problems plagued monitor operation; my 
> theory at the time was that their USB "glue" silicon simply couldn't 
> keep up with the load.
> 
>  - Solomon


