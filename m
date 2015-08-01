Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbHAPzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2015 11:55:48 -0400
Date: Sat, 1 Aug 2015 08:55:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Dean Lee <dean.lee@atmel.com>, Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org,
	Shraddha Barke <shraddha.6596@gmail.com>
Subject: Re: [PATCH] Staging:wilc1000 :Remove typedef from struct
Message-ID: <20150801155547.GB9572@kroah.com> (sfid-20150801_175612_947631_2B3A3F18)
References: <1438321127-8120-1-git-send-email-shraddha.6596@gmail.com>
 <20150731205213.GF1650@kroah.com>
 <20150801045526.GA4150@sudip-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150801045526.GA4150@sudip-pc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 01, 2015 at 10:25:26AM +0530, Sudip Mukherjee wrote:
> On Fri, Jul 31, 2015 at 01:52:13PM -0700, Greg Kroah-Hartman wrote:
> > On Fri, Jul 31, 2015 at 11:08:47AM +0530, Shraddha Barke wrote:
> > > This patch fixes the following checkpatch.pl warning:
> > > 
> > > WARNING: do not add new typedefs
> > > 
> > > Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> > > ---
> <snip>
> > > -typedef enum {
> > > +enum {
> > >  	CLASS1_FRAME_TYPE      = 0x00,
> > >  	CLASS2_FRAME_TYPE      = 0x01,
> > >  	CLASS3_FRAME_TYPE      = 0x02,
> > 
> > Did you test-build this change?
> This enum is not used anywhere. So did not affect the build.

Then it should be deleted :)
