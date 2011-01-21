Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1AUPLn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 10:11:43 -0500
Date: Fri, 21 Jan 2011 07:12:46 -0800
From: Greg KH <gregkh@suse.de>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Greg KH <greg@kroah.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: fix suspend/resume issue in
 brcmsmac
Message-ID: <20110121151246.GA29290@suse.de>
References: <1294855167-3718-1-git-send-email-arend@broadcom.com>
 <20110120201753.GA18529@kroah.com>
 <400C43189542CE41BC0A5B252FC90136952F05955A@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F05955A@SJEXCHCCR02.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
