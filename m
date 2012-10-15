Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2JOKzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:55:14 -0400
Message-ID: <1350298546.27801.1.camel@jlt4.sipsolutions.net> (sfid-20121015_125524_510587_D11D9FC8)
Subject: Re: [PATCH 0/3] wireless: only use WLAN_EID_VENDOR_SPECIFIC
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Mon, 15 Oct 2012 12:55:46 +0200
In-Reply-To: <1350037696-23747-1-git-send-email-arend@broadcom.com> (sfid-20121012_122844_139948_31776ADC)
References: <1350037696-23747-1-git-send-email-arend@broadcom.com>
	 (sfid-20121012_122844_139948_31776ADC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-12 at 12:28 +0200, Arend van Spriel wrote:
> Getting rid of duplicate definitions in linux/ieee80211.h.
> 
> Patches are intended for 3.8 and apply to the wireless-next
> repository.

I applied them all and fixed up libipw for you :)

johannes

