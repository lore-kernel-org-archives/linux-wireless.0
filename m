Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47758 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758302Ab3BKTFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 14:05:21 -0500
Message-ID: <511940E6.7010303@hauke-m.de> (sfid-20130211_200524_992762_10787BF4)
Date: Mon, 11 Feb 2013 20:05:10 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac and IBSS
References: <1360604039.1559.44.camel@dcbw.foobar.com>
In-Reply-To: <1360604039.1559.44.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 06:33 PM, Dan Williams wrote:
> Hi,
> 
> Had a bug report that a 4313 doesn't support IBSS mode, and dug around
> and found out that brcmsmac only supports STA mode.  Is that really true
> and there's no IBSS support in the smac driver?  Is that a firmware or
> driver limitation?  Seems odd that this got missed during the merge
> reviews as IBSS is pretty basic functionality that all the kernel wifi
> drivers have had for 5 or 7 years.
> 
> Dan

I started to add AP mode support to brcmsmac. The hardware is capable of
all the stuff needed. At least the firmware extracted from the
proprietary driver is also capable of everything needed, but I think the
normal firmware has the same features. At least the BCM43224 is used in
standalone APs.

Hauke
