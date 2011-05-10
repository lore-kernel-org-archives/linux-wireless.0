Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:41849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1EJS0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 14:26:44 -0400
Date: Tue, 10 May 2011 11:12:08 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/10] staging: brcm80211: cleanup unnecessary functions
 from wlc_ampdu.c
Message-ID: <20110510181208.GA3396@kroah.com> (sfid-20110510_202647_882014_593BC4A0)
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 09, 2011 at 04:33:20PM +0200, Arend van Spriel wrote:
> Couple of functions are not used or empty and have been removed.

This patch doesn't apply on top of all of the other brcm80211 patches
sent me.  Care to redo this series and resend after syncing up with the
next linux-next tree?

thanks,

greg k-h
