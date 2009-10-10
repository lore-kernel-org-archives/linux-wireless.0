Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:55911 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZJJD42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 23:56:28 -0400
Message-ID: <4AD005C5.4090705@lwfinger.net>
Date: Fri, 09 Oct 2009 22:55:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-10-09-01-07 uploaded (b43)
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org> <20091009154732.af708827.rdunlap@xenotime.net>
In-Reply-To: <20091009154732.af708827.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2009 05:47 PM, Randy Dunlap wrote:
> 
> In file included from mmotm-2009-1009-0107/drivers/net/wireless/b43/b43.h:12,
>                  from mmotm-2009-1009-0107/drivers/net/wireless/b43/main.c:47:

These warnings occur because CONFIG_B43_LEDS is not set, probably
because CONFIG_MAC80211_LEDS is not set. See the patch in
http://marc.info/?l=linux-wireless&m=125509895406304&w=2.

Larry
