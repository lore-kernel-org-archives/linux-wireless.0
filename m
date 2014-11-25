Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49435 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaKYTaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 14:30:10 -0500
Date: Tue, 25 Nov 2014 14:20:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] brcmsmac: extend hardware info shown in debugfs
Message-ID: <20141125192025.GI15476@tuxdriver.com> (sfid-20141125_203014_670774_EF32A05A)
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
 <1416518822-29585-4-git-send-email-arend@broadcom.com>
 <20141124215049.GA4484@tuxdriver.com>
 <54747232.3030503@broadcom.com>
 <20141125184945.GD15476@tuxdriver.com>
 <20141125190533.GH15476@tuxdriver.com>
 <5474D581.5010909@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5474D581.5010909@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 08:16:17PM +0100, Arend van Spriel wrote:
> On 11/25/14 20:05, John W. Linville wrote:
> >On Tue, Nov 25, 2014 at 01:49:45PM -0500, John W. Linville wrote:
> >>On Tue, Nov 25, 2014 at 01:12:34PM +0100, Arend van Spriel wrote:
> >>>On 11/24/14 22:50, John W. Linville wrote:
> >>>>Hmmm...I'm not sure why, but this is causing problems for me...
> >>>>
> >>>>ERROR: "brcmu_boardrev_str" [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
> >>>
> >>>I am confused as well. I did not have such an issue. The function is
> >>>provided by brcmutil.ko (patch 2/4) and I did an EXPORT_SYMBOL and added it
> >>>to the include file. Missing something? Also I don't see this issue over
> >>>here. I will do a clean build on the wireless-next tree and see if I can
> >>>reproduce this.
> >>
> >>I did a clean build after applying the patches in question, and I
> >>still got the same issue at link time.  I'll attach my .config for
> >>you to try.
> >
> >I think that was too big...trying the compressed version...
> 
> I received both. I assume he commit mentioned below is without the patches.
> 
> Regards,
> Arend
> 
> >>FWIW, I am building wireless-testing at commit
> >>733ea24c8c98d99c747b89710e520ac6e9f3951b.
> >
> >John

That commit includes all 4 patches.  I reverted the last three later
in the wireless-testing history.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
