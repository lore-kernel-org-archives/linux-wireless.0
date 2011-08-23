Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48623 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab1HWTzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 15:55:04 -0400
Date: Tue, 23 Aug 2011 12:52:39 -0700
From: Greg KH <greg@kroah.com>
To: Ali Bahar <ali@internetdog.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] staging: r8712u: Most return-values changed from -1
 to proper errno macros.
Message-ID: <20110823195239.GA17945@kroah.com> (sfid-20110823_215508_941565_7F8455BF)
References: <1310799573-4407-1-git-send-email-ali@internetDog.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310799573-4407-1-git-send-email-ali@internetDog.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 16, 2011 at 02:59:33PM +0800, Ali Bahar wrote:
> The ioctl handlers were frequently returning -1 upon failure. Most of
> these have now been changed to proper errno macros.
> The few remaining ones have been left untouched because either the
> handler is not called (and so cannot be tested), or the function never
> fails (and so cannot be system-tested), or requires new code to
> distinguish its failures.
> 
> Signed-off-by: Ali Bahar <ali@internetDog.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>

This fails to apply cleanly anymore, can you refresh it, and your other
outstanding patches and resend?

thanks,

greg k-h
