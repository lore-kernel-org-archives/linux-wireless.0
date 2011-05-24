Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1EXM50 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 08:57:26 -0400
Date: Tue, 24 May 2011 05:34:55 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Vossen <rvossen@broadcom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	frankyl@broadcom.com
Subject: Re: [PATCH] staging: brcm80211: fix for 'multiple definition of
 wl_msg_level' build err
Message-ID: <20110524123455.GB31517@suse.de> (sfid-20110524_145729_806803_1A0507C3)
References: <1306236921-30522-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306236921-30522-1-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 24, 2011 at 01:35:21PM +0200, Roland Vossen wrote:
> As reported by Linus.
> 
> Signed-off-by: Roland Vossen <rvossen@broadcom.com>
> ---

When someone else reports it, then you need to say so this way:
 Reported-by: Linus Torvalds <torvalds@linux-foundation.org>

I'll add it to the patch this time, but please be more careful next
time.

thanks,

greg k-h
