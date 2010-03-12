Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41185 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0CLEog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 23:44:36 -0500
Subject: Re: [PATCH 1/5] compat-wireless: rename {free,alloc}_ieee80211 to
 {free,alloc}_libipw
From: Pavel Roskin <proski@gnu.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, mcgrof@infradead.org
In-Reply-To: <69e28c911003111816m4bf0d04dnc94a387b3d42f05b@mail.gmail.com>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
	 <1268343167-2961-3-git-send-email-hauke@hauke-m.de>
	 <69e28c911003111816m4bf0d04dnc94a387b3d42f05b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 23:44:32 -0500
Message-Id: <1268369072.6763.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-12 at 03:16 +0100, Gábor Stefanik wrote:

> I believe this should be done upstream for 2.6.35 as well - this
> "_ieee80211" is not a reference to the name of  the IEEE 802.11
> specification, but rather to the old name of libipw - "ieee80211";
> this was somehow missed during the libipw rename.

Also the "ieee80211" prefix is used in libipw messages, and should be
replaced as well.

However, one thing may need to keep the original name.  If
CONFIG_LIBIPW_DEBUG is enabled, /proc/net/ieee80211 is created.  Perhaps
it would be unhelpful to break that user interface for aesthetic
purposes.

-- 
Regards,
Pavel Roskin
