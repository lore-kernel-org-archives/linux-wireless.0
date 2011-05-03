Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1ECTtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 15:49:43 -0400
Date: Tue, 3 May 2011 12:46:49 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sukesh Srikakula <sukeshs@broadcom.com>
Subject: Re: [PATCH 2/2] brcm80211: Fix for suspend/resume bug
Message-ID: <20110503194649.GA6322@kroah.com> (sfid-20110503_214946_431148_9CFA64C3)
References: <1304406057-8722-1-git-send-email-sukeshs@broadcom.com>
 <1304406057-8722-3-git-send-email-sukeshs@broadcom.com>
 <20110503121522.GB22674@suse.de>
 <4DBFF628.6040502@broadcom.com>
 <20110503130049.GA29438@suse.de>
 <4DBFFE80.3030305@broadcom.com>
 <20110503131157.GA29915@suse.de>
 <4DC00050.5000009@broadcom.com>
 <4DC0061E.8020504@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DC0061E.8020504@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 03, 2011 at 03:41:50PM +0200, Arend van Spriel wrote:
> On 05/03/2011 03:17 PM, Arend van Spriel wrote:
> >On 05/03/2011 03:11 PM, Greg KH wrote:
> >>On Tue, May 03, 2011 at 03:09:20PM +0200, Arend van Spriel wrote:
> >>>On 05/03/2011 03:00 PM, Greg KH wrote:
> >>>>On Tue, May 03, 2011 at 02:33:44PM +0200, Arend van Spriel wrote:
> >>>>>On 05/03/2011 02:15 PM, Greg KH wrote:
> >>>>>>On Tue, May 03, 2011 at 12:00:57AM -0700, sukeshs@broadcom.com wrote:
> >>>>>>>   #if defined(CONFIG_PM_SLEEP)
> >>>>>>>
> >>>>>>>+extern volatile bool dhd_mmc_suspend;
> >>>>>>This does not do what you think it does.
> >>>>>Hi Greg,
> >>>>>
> >>>>>I posted the 'catchup' patch set and I rebased it on '[PATCH 1/2]
> >>>>>brcm80211: FIX for TKIP GTK bug' from Sukesh. The only other two
> >>>>>patches I saw on the linuxdriver list are:
> >>>>You rebased on a 1/2 patch in a series with an invalid 0/2 email?
> >>>>
> >>>>{sigh}
> >>>Sorry.
> >>>>I dropped that patch as the whole series needed to be resent, do you
> >>>>want me to apply that one patch before yours?
> >>>I can resend my series if that is more convenient for you.
> >>Please, but just send it to me, I doubt everyone wants to see 60+
> >>patches again on the list.
> >Ok. Just for this time I will agree to break the rules ;-)
> 
> Hi Greg,
> 
> I rebase and regenerated the patch files. Did a diff before
> resending them with the previous set and there are no relevant
> differences so the patches I sent this morning are ok.

Great, I've applied them all now.

greg k-h
