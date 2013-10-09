Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3JIHsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 03:48:37 -0400
Message-ID: <1381304913.14186.3.camel@jlt4.sipsolutions.net> (sfid-20131009_094843_476316_61CAEA37)
Subject: Re: [PATCHv2 1/3] nl80211/cfg80211: enable DFS for IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 09 Oct 2013 09:48:33 +0200
In-Reply-To: <1381164067-4830-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1381164067-4830-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1381164067-4830-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-07 at 18:41 +0200, Simon Wunderlich wrote:
> To use DFS in IBSS mode, userspace is required to react to radar events.
> It can inform nl80211 that it is capable of doing so by adding a
> NL80211_ATTR_DFS_CAPABLE attribute when joining the IBSS.
> 
> This attribute is supplied to let the kernelspace know that the
> userspace application can and will handle radar events, e.g. by
> intiating channel switches to a valid channel. DFS channels may
> only be used if this attribute is supplied and the driver supports
> it. Driver support will be checked even if a channel without DFS
> will be initially joined, as a DFS channel may be chosen later.

Applied, fixed the attribute name above.

johannes

