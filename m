Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40522 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbcEaKML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 06:12:11 -0400
Message-ID: <1464689527.3076.9.camel@sipsolutions.net> (sfid-20160531_121228_006355_6FABA16D)
Subject: Re: [PATCH] mac80211_hwsim: Add missing check for HWSIM_ATTR_SIGNAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Willi <martin@strongswan.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 31 May 2016 12:12:07 +0200
In-Reply-To: <1463136108-4434-1-git-send-email-martin@strongswan.org>
References: <1463136108-4434-1-git-send-email-martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-05-13 at 12:41 +0200, Martin Willi wrote:
> A wmediumd that does not send this attribute causes a NULL pointer
> dereference, as the attribute is accessed even if it does not exist.
> 
> The attribute was required but never checked ever since userspace
> frame
> forwarding has been introduced. The issue gets more problematic once
> we
> allow wmediumd registration from user namespaces.
> 
Applied, thanks.

johannes
