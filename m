Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbbHEQ0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:26:20 -0400
Date: Wed, 5 Aug 2015 09:26:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] drivers: staging: wilc1000: use 'void' for no
 arguments functions
Message-ID: <20150805162619.GA21870@kroah.com> (sfid-20150805_182638_534574_BC1BF8C6)
References: <1438791182-9178-1-git-send-email-csgorentla@gmail.com>
 <1438791182-9178-2-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438791182-9178-2-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 05, 2015 at 09:43:00PM +0530, Chandra S Gorentla wrote:
> Added 'void' keyword in the paranthesis of function definitions, when
> there are no arguments to the functions.  This fixes the checkpatch.pl
> error - "Bad function definition 'function()' should probably be
> function(void)".
> 
> ---
>  drivers/staging/wilc1000/linux_mon.c  | 2 +-
>  drivers/staging/wilc1000/linux_wlan.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch does not have a Signed-off-by: line.  Please read the
  kernel file, Documentation/SubmittingPatches and resend it after
  adding that line.  Note, the line needs to be in the body of the
  email, before the patch, not at the bottom of the patch or in the
  email signature.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
