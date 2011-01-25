Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44151 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1AYO6X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 09:58:23 -0500
Date: Tue, 25 Jan 2011 19:41:05 +0800
From: Greg KH <gregkh@suse.de>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: bugfix for softmac crash on multi
 cpu configurations
Message-ID: <20110125114105.GA15568@suse.de>
References: <1295952716-16161-1-git-send-email-rvossen@broadcom.com>
 <20110125111813.GA14763@suse.de>
 <400C43189542CE41BC0A5B252FC90136952F08D15D@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F08D15D@SJEXCHCCR02.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 03:24:38AM -0800, Roland Vossen wrote:
> >Should this also go to the .37 stable kernel tree?
> 
> Yes it should. Should I send you a patch for the .37 stable kernel tree ?

Not at the moment, I'll just mark it for the stable tree, and if it
doesn't apply there properly, I'll email you asking for an updated
version.

For more details about the stable kernel process, see the file,
Documentation/stable_kernel_rules.txt

thanks,

greg k-h
