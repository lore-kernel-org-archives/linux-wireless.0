Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1DTRU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 13:20:27 -0400
Date: Wed, 20 Apr 2011 09:08:35 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Vossen <rvossen@broadcom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: better feedback to user on ioctl
 errors
Message-ID: <20110420160835.GA25298@suse.de>
References: <1303288719-3036-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303288719-3036-1-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 20, 2011 at 10:38:39AM +0200, Roland Vossen wrote:
> Messages are now logged that provide the user with a clue on what went wrong.

Nice, you just provided a way for userspace to annoy the system log
readers by flooding it with useless information. :)

No, this kind of patch is not acceptable, sorry.  Your userspace tools
should know better.  Or at the very least, make this a debugging option
in the driver, not dev_err().

thanks,

greg k-h
