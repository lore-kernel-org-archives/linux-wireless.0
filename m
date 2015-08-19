Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbHSC7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 22:59:44 -0400
Date: Tue, 18 Aug 2015 19:59:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Arend van Spriel <arend@broadcom.com>
Subject: Re: [PATCHv3] staging: wilc1000: replace MALLOC_WILC_BUFFER() macro
 to avoid possible memory leak
Message-ID: <20150819025942.GD4588@kroah.com> (sfid-20150819_045948_592179_9EDD8C88)
References: <55D238D4.20800@broadcom.com>
 <ba3c67af8cbe5658154084a165785c637e5a2bc8.1439853139.git.raphael.beamonte@gmail.com>
 <20150817234628.GK5558@mwanda>
 <20150818091530.GH5610@mwanda>
 <CAE_Gge0EDaE=zQp9YBDJSd_1VjU1a8-zoPkyKxqPc2THi2b=eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAE_Gge0EDaE=zQp9YBDJSd_1VjU1a8-zoPkyKxqPc2THi2b=eQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2015 at 01:06:39PM -0400, Raphaël Beamonte wrote:
> 2015-08-18 5:15 GMT-04:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > To be honest, I have lost track of this patchset.  If you are planning
> > to redo the other patches can you send it in a new thread?
> 
> Actually, Greg already included the "return statement" and
> "DECLARE_WILC_BUFFER" ones.
> The replacement of printk by netdev_* needs more work on my side to
> get the net_device to be able to use the netdev_* functions.
> And apparently Greg already received another patch with the
> "FREE_WILC_BUFFER" replacement, though I don't see it in the
> staging-testing tree yet.

Maybe it was something else, but it would not apply.  Please use git
rebase to figure it out and resend all of your outstanding patches, I
too am confused at this point.

thanks,

greg k-h
