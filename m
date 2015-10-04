Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbbJDKKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 06:10:22 -0400
Date: Sun, 4 Oct 2015 11:10:19 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: Re: [PATCH 2/2] drivers: staging: wilc1000: Call kfree only for
 error cases
Message-ID: <20151004101019.GA23448@kroah.com> (sfid-20151004_121038_725900_5BC9D9E4)
References: <1443864450-18167-1-git-send-email-csgorentla@gmail.com>
 <1443864450-18167-2-git-send-email-csgorentla@gmail.com>
 <20151004084457.GB24589@kroah.com>
 <20151004091631.GS7289@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151004091631.GS7289@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 04, 2015 at 12:16:31PM +0300, Dan Carpenter wrote:
> On Sun, Oct 04, 2015 at 09:44:57AM +0100, Greg KH wrote:
> > Aren't you now leaking memory as you aren't freeing pstrMessage and the
> > buffer on the "normal" return path?
> 
> It's supposed to.  It's a bug fix.  I explained to him in the first
> version that his changelog sucks.

Ok, well, it still sucks :)

And it's out of my queue, so I'll wait for the next spin of this
series...

greg k-h
