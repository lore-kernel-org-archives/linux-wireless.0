Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26030 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab0IHWWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 18:22:15 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 15:22:10 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Greg KH <greg@kroah.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Wed, 8 Sep 2010 15:22:13 -0700
Subject: RE: [PATCH] staging: ath6kl: Replacing the symbolic link to the
	hw.0 directory with a new directory 'hw' while retaining the	contents. This
 will help with the cases where the driver fails to	compile if the link was
 not setup properly.
Message-ID: <35B17FE5076C7040809188FBE7913F983F2381DA36@SC1EXMB-MBCL.global.atheros.com>
References: <1283905487-1471-1-git-send-email-vmehta@atheros.com>
 <20100908090538.GA21218@kroah.com>
In-Reply-To: <20100908090538.GA21218@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, September 08, 2010 2:06 AM
> To: Vipin Mehta
> Cc: linux-wireless@vger.kernel.org; devel@driverdev.osuosl.org
> Subject: Re: [PATCH] staging: ath6kl: Replacing the symbolic link to the
> hw.0 directory with a new directory 'hw' while retaining the contents.
> This will help with the cases where the driver fails to compile if the
> link was not setup properly.
> 
> On Tue, Sep 07, 2010 at 05:24:47PM -0700, Vipin Mehta wrote:
> > Signed-off-by: Vipin Mehta <vmehta@atheros.com>
> 
> What's with the long Subject: ?
Sorry. Still getting used to git.
> 
> Anyway, this patch fails to apply, it seems you want to just delete the
> symlink, which you might need to tell git that you want to generate a
> patch that does this.  For how you do that, I don't really know, sorry.
> 
> If you want, just send a patch that does the proper thing for the
> existing files to get everything to build correctly, and then tell me to
> remove the symlink by hand, which I can do.  That might be the easiest
> thing to do here.
I have sent you another patch that I generated using the option '-M'. the option allows git-format-patch to detect renames which is what I intended to do. The patch is much smaller and readable. Hopefully, it will apply this time. BTW, I usually test the patches before I send out. Not sure why the earlier one did not work as it works for me.
> 
> thanks,
> 
> greg k-h
