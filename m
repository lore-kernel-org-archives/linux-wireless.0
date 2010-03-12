Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:50188 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0CLCQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 21:16:59 -0500
Received: by fg-out-1718.google.com with SMTP id l26so179698fgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 18:16:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268343167-2961-3-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
	<1268343167-2961-3-git-send-email-hauke@hauke-m.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 12 Mar 2010 03:16:38 +0100
Message-ID: <69e28c911003111816m4bf0d04dnc94a387b3d42f05b@mail.gmail.com>
Subject: Re: [PATCH 1/5] compat-wireless: rename {free,alloc}_ieee80211 to
	{free,alloc}_libipw
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 11, 2010 at 10:32 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> {free,alloc}_ieee80211 are also defined by ieee80211 module for example
> used on kernel 2.6.26. Without this patch ipwlib will not load on this
> kernel, because of a duplicate symbol.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

I believe this should be done upstream for 2.6.35 as well - this
"_ieee80211" is not a reference to the name of  the IEEE 802.11
specification, but rather to the old name of libipw - "ieee80211";
this was somehow missed during the libipw rename.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
