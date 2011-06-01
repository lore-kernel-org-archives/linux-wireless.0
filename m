Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4359 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab1FARR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 13:17:27 -0400
Message-ID: <4DE67418.7060006@broadcom.com> (sfid-20110601_191731_009339_8FD1BF2F)
Date: Wed, 1 Jun 2011 19:17:12 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Jonas Gorski" <jonas.gorski@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/83] staging: brcm80211: replaced #ifdef __mips__
 sections by W_REG_FLUSH
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-8-git-send-email-rvossen@broadcom.com>
 <BANLkTimhuScx64utGbS_g0OU-S8B5G2MXQ@mail.gmail.com>
In-Reply-To: <BANLkTimhuScx64utGbS_g0OU-S8B5G2MXQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jonas,

> Checking for CONFIG_BCM47XX instead of __mips__ would be a bit cleaner
> and less broad. Although the bcm47x6s are not supported by BCM47XX
> yet, when the support gets added they will be caught by this without
> affecting other mips platforms.
> Perhaps a clean solution would be to introduce a quirk option/value in
> the pci_bus or pci_dev the driver can use to decide at runtime whether
> it needs this workaround or not. This would also allow other drivers
> to check for it if they are also affected by it (even if the
> probability of this is rather low - at least I haven't seen a bcm47x6
> yet with anything other than a broadcom wifi connected to its pcie
> ;-).

Further mips cleanup is in the pipeline, your suggestion is certainly a 
good one. A similar suggestion has been made by GregKH in the past.

However, the focus of the patch set is on code cleanup. So my intention 
is to rewrite code to make it cleaner, without changing existing behavior.

Your (and Gregs) suggestion have been noted down and will get a 
follow-up in the future.

Thanks for the feedback,

Roland.

