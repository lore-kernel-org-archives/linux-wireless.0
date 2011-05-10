Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1EJT0H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:26:07 -0400
Date: Tue, 10 May 2011 12:26:04 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/10] staging: brcm80211: cleanup unnecessary functions
 from wlc_ampdu.c
Message-ID: <20110510192604.GA11348@kroah.com> (sfid-20110510_212612_782858_187A5BE0)
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
 <20110510181208.GA3396@kroah.com>
 <4DC98CF2.9050804@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DC98CF2.9050804@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2011 at 09:07:30PM +0200, Arend van Spriel wrote:
> On 05/10/2011 08:12 PM, Greg KH wrote:
> >On Mon, May 09, 2011 at 04:33:20PM +0200, Arend van Spriel wrote:
> >>Couple of functions are not used or empty and have been removed.
> >This patch doesn't apply on top of all of the other brcm80211 patches
> >sent me.  Care to redo this series and resend after syncing up with the
> >next linux-next tree?
> According to the email messages 'patch "staging: brcm80211: ..."
> added to staging tree' you dropped four patches in this series. Do
> you want me to resend those or the entire series. I prefer only
> resending the dropped ones, but it is your call.

Please resend only the dropped ones, as I can't do anything with ones
I've already applied :)

thanks,

greg k-h
