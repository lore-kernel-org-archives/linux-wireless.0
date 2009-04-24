Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:50235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560AbZDXXDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 19:03:11 -0400
Date: Fri, 24 Apr 2009 15:58:20 -0700
From: Greg KH <greg@kroah.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090424225820.GE3343@kroah.com> (sfid-20090425_010317_358329_3DFC4C4D)
References: <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network> <20090419170950.GA28885@storm.local.network> <49EB8119.1020402@lwfinger.net> <20090419200146.GB28885@storm.local.network> <20090419223218.GA30599@kroah.com> <20090424110329.GJ2830@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090424110329.GJ2830@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 24, 2009 at 07:03:29AM -0400, Forest Bond wrote:
> Hi Greg,
> 
> On Sun, Apr 19, 2009 at 03:32:18PM -0700, Greg KH wrote:
> > On Sun, Apr 19, 2009 at 04:01:46PM -0400, Forest Bond wrote:
> > > On Sun, Apr 19, 2009 at 02:52:57PM -0500, Larry Finger wrote:
> > > > Forest Bond wrote:
> > > > > 
> > > > > However, I did have a question:
> > > > > 
> > > > > The vt6655 driver builds viawget.ko, and the vt6656 driver builds vntwusb.ko.
> > > > > Should the directories be named "viawget" and "vntwusb," respectively, or is it
> > > > > appropriate for them to be named "vt6655" and "vt6656"?
> > > > 
> > > > Of course Greg has the final say, but I vote to keep the directories with the
> > > > vt6656 name and change the name of the driver, which is defined in  the line
> > > > #define DEVICE_NAME "vntwusb" in file include/device_cfg.h in the vendor driver.
> > > 
> > > This makes sense to me.  I'll proceed this way for now.  Greg, let me know if
> > > you'd prefer I didn't do this.
> > 
> > No objection from me.
> 
> The following git repository has a vt6655 branch and a vt6656 branch:
> 
>   http://www.alittletooquiet.net/media/code/vt665x.git
> 
> The vt6655 branch contains pretty much all of the work I'll likely be able to do
> for that driver.  The vt6656 branch needs more work.  I've not gone farther than
> build-testing either, at this point.
> 
> As I've mentioned before, some of this kind of work is really a bit outside my
> usual domain, so if you do look at it, I'd appreciate feedback.
> 
> Feel free to make requests.

Could you send it out as patches so it's easier to review?

thanks,

greg k-h
