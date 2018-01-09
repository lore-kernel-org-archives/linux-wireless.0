Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753412AbeAIO3x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 09:29:53 -0500
Date: Tue, 9 Jan 2018 15:29:54 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH] staging: wilc1000: removed typedef from enum BSSTYPE_T
Message-ID: <20180109142954.GA608@kroah.com> (sfid-20180109_152956_791978_70397A17)
References: <1515488862-8201-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515488862-8201-1-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 09, 2018 at 02:37:42PM +0530, Ajay Singh wrote:
> This patch removes typedef from enum BSSTYPE_T and
> rename it to bss_types.
> 
> It fixes "WARNING: do not add new typdefs" warning
> reported by checkpatch.pl.
> 
> Signed-off-by: ajaysk <ajay.kathat@microchip.com>

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

- You sent multiple patches, yet no indication of which ones should be
  applied in which order.  Greg could just guess, but if you are
  receiving this email, he guessed wrong and the patches didn't apply.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for a description of how
  to do this so that Greg has a chance to apply these correctly.

- You did not use your real name.  Signed-off-by: and From: has to have
  a real name associated with it.  Use whatever you sign legal documents
  with, no anonymous patches are allowed.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
