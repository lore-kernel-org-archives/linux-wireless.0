Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab1ECNBy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 09:01:54 -0400
Date: Tue, 3 May 2011 06:00:49 -0700
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Sukesh Srikakula <sukeshs@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] brcm80211: Fix for suspend/resume bug
Message-ID: <20110503130049.GA29438@suse.de> (sfid-20110503_150157_155209_22260654)
References: <1304406057-8722-1-git-send-email-sukeshs@broadcom.com>
 <1304406057-8722-3-git-send-email-sukeshs@broadcom.com>
 <20110503121522.GB22674@suse.de>
 <4DBFF628.6040502@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DBFF628.6040502@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 03, 2011 at 02:33:44PM +0200, Arend van Spriel wrote:
> On 05/03/2011 02:15 PM, Greg KH wrote:
> >On Tue, May 03, 2011 at 12:00:57AM -0700, sukeshs@broadcom.com wrote:
> >>  #if defined(CONFIG_PM_SLEEP)
> >>
> >>+extern volatile bool dhd_mmc_suspend;
> >This does not do what you think it does.
> 
> Hi Greg,
> 
> I posted the 'catchup' patch set and I rebased it on '[PATCH 1/2]
> brcm80211: FIX for TKIP GTK bug' from Sukesh. The only other two
> patches I saw on the linuxdriver list are:

You rebased on a 1/2 patch in a series with an invalid 0/2 email?

{sigh}

I dropped that patch as the whole series needed to be resent, do you
want me to apply that one patch before yours?

thanks,

greg k-h
