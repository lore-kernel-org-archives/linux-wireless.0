Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbAQO6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2015 09:58:47 -0500
Date: Sat, 17 Jan 2015 06:58:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Poklop <peter.poklop@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8723au: fix space coding style issue in
 os_intfs.c
Message-ID: <20150117145846.GA26836@kroah.com> (sfid-20150117_155911_254334_58ABC871)
References: <1421506365-9171-1-git-send-email-peter.poklop@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421506365-9171-1-git-send-email-peter.poklop@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 17, 2015 at 03:52:45PM +0100, Peter Poklop wrote:
> From: Peter <peter.poklop@gmail.com>

This name doesn't match up with:

> 
> This patch fixes the checkpatch.pl warning:
> 
> WARNING: space prohibited before semicolon
> 
> Signed-off-by: Peter Poklop <peter.poklop@gmail.com>

this name, why?

Please fix up and resend.

Or better yet, don't even include the first "From:" line, as it's not
needed in this case, right?

thanks,

greg k-h
