Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44727 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbZATXyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 18:54:20 -0500
Date: Tue, 20 Jan 2009 18:56:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <gregkh@suse.de>
Cc: Christian Lamparter <chunkeey@web.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Artur Skawina <art.08.09@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Linux wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -stable] p54usb: fix traffic stalls / packet drop
Message-ID: <20090120235626.GA3094@tuxdriver.com> (sfid-20090121_005425_606285_F64DB95D)
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.vUD.KKRdJB@chimera> <200901202311.11854.chunkeey@web.de> <20090120223957.GA6088@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090120223957.GA6088@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 02:39:57PM -0800, Greg KH wrote:
> On Tue, Jan 20, 2009 at 11:11:11PM +0100, Christian Lamparter wrote:
> > All p54usb devices need a explicit termination packet, in oder to finish the pending transfer properly.
> > Else, the firmware could freeze, or simply drop the frame.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > Cc: stable <stable@kernel.org>
> > ---
> > Attached is the patch is for the stable series only.
> > Bugzilla reference: http://bugzilla.kernel.org/show_bug.cgi?id=12260
> > (wireless-testing needs a different one)
> 
> What do you mean, this is for 2.6.28-stable or 2.6.27-stable only, and
> not 2.6.29?  Why?

At least part of that patch is already in 2.6.29.  I think Christian
may have combined another patch into the -stable version, one that
he posted today for -rc inclusion.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
