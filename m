Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3577 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab1AUVk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:40:59 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Greg KH" <gregkh@suse.de>
cc: "Greg KH" <greg@kroah.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 21 Jan 2011 13:36:10 -0800
Subject: RE: [PATCH] staging: brcm80211: fix suspend/resume issue in
 brcmsmac
Message-ID: <400C43189542CE41BC0A5B252FC90136952F059562@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1294855167-3718-1-git-send-email-arend@broadcom.com>
 <20110120201753.GA18529@kroah.com>
 <400C43189542CE41BC0A5B252FC90136952F05955A@SJEXCHCCR02.corp.ad.broadcom.com>,<20110121151246.GA29290@suse.de>
In-Reply-To: <20110121151246.GA29290@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

I think you miss my point. I currently have a suspend/resume issue with 2.6.37 and 2.6.38-rc1
that is not related to our driver as I did suspend/resume without loading our driver module.

Gr. AvS
________________________________________
From: Greg KH [gregkh@suse.de]
Sent: Friday, January 21, 2011 4:12 PM
To: Arend Van Spriel
Cc: Greg KH; devel@linuxdriverproject.org; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: fix suspend/resume issue in brcmsmac

On Fri, Jan 21, 2011 at 06:37:54AM -0800, Arend Van Spriel wrote:
> Hi Greg,
>
> I did not retest the suspend/resume change functionally (only compiled it). I decided
> to do that on v2.6.38-rc1 to be sure and on my system the suspend works. However,
> upon resume my system reboots without any feedback. System seem to come to
> live (DVD spinning) and then BIOS boot screen pops up. So I tried suspend/resume
> without our driver loaded. Results were the same. Also 2.6.37 shows same behaviour.
>
> On 2.6.37-rc5 I did not have any issues and suspend/resume worked for our driver
> and the kernel in general. Anyone else observed such behaviour?

Yes, lots of other people reported problems with this, I thought you got
the reports (like from Jon Masters?)

thanks,

greg k-h


