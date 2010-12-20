Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34989 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab0LTAGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 19:06:06 -0500
Message-ID: <4D0E9DE3.8050100@hauke-m.de>
Date: Mon, 20 Dec 2010 01:05:55 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: Do not use legacy PCI power management
References: <201010160036.17653.rjw@sisk.pl> <201012200032.21704.rjw@sisk.pl>
In-Reply-To: <201012200032.21704.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2010 12:32 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The ath9k driver uses legacy PCI power management (system suspend
> and resume) callbacks, so make it use struct dev_pm_ops callbacks and
> let the PCI subsystem handle all of the PCI-specific details of
> system power transitions.
> 
> This change has been tested on Acer Ferrari One with the
> Atheros AR928X PCI Express network adapter (rev. 01).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Hi,
> 
> This patch has been sent already once under a slightly different subject
> and with a different changelog.  I'm not sure what happened to it that time,
> so here it goes again.
> 
> I'm quite confident it doesn't break things and it simplifies the driver's
> suspend and resume routines quite a bit, so please apply.
> 
> Thanks,
> Rafael
> 
Hi Rafael,

Your patch was already applied (see commit
f0e94b479c987abef17eb18e5c8e0ed178d00cd4 in linux-next) or didn't I got
your problem?

Hauke
