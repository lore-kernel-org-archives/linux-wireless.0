Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab1GFCeI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 22:34:08 -0400
Date: Tue, 5 Jul 2011 18:58:29 -0700
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <greg@kroah.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and bug
 fixed
Message-ID: <20110706015829.GA15988@suse.de> (sfid-20110706_043416_189944_610DD6AA)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <20110705165949.GA18531@kroah.com>
 <4E1362D5.2040806@broadcom.com>
 <4E136A27.6060207@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E136A27.6060207@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 05, 2011 at 09:46:47PM +0200, Arend van Spriel wrote:
> On 07/05/2011 09:15 PM, Arend van Spriel wrote:
> >On 07/05/2011 06:59 PM, Greg KH wrote:
> >>On Wed, Jun 29, 2011 at 04:46:24PM -0700, Franky Lin wrote:
> >>>Most of these patches are brcmfmac cleanup.
> >>Not all of them applied, care to redo the ones that didn't and resend
> >>them?
> >>
> >>thanks,
> >>
> >>greg k-h
> >Will do when I figured out which ones are not applying. Franky, as are
> >all valley broadcom folks, is not in today (fourth of july aftermath).
> >Here in Holland we have other days to celebrate so taking over from him.
> >Can you provide me the info about the not applying patches. I applied
> >them all on top of staging-next as it was this morning and that went
> >fine. Did we miss some brcm80211 patches not coming from us? I will
> >start digging here to find out, but you are more than welcome to provide
> >any info.
> >
> >Gr. AvS
> 
> Hi Greg,
> 
> This is what I excavated so far. Looking at git.kernel.org it seems
> like patch 92 in the series got applied at the end of the series. Up
> to patch 92 it went fine, but it started to derail from there. I
> have clear picture which patches are missing and will resend them.

Yes, I messed up.  I sorted by "brcm" and applied the patches there,
missing the fact that patch 92 was spelled wrong, so I missed it.

Then I went back and applied that one after figuring it out, but you did
at the same time.

I'll queue these up in a bit after I get the kids to bed, thanks for
resending them and sorry for the mixup, it was my fault.

greg k-h
