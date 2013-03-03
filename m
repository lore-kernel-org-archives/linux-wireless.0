Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3CCRVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 12:21:01 -0500
Message-ID: <1362331252.8226.2.camel@jlt4.sipsolutions.net> (sfid-20130303_182106_515283_F6B432AE)
Subject: Re: [PATCH 05/13] brcmfmac: only do auth_type workaround when no
 WPA or RSN IE is provided
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 03 Mar 2013 18:20:52 +0100
In-Reply-To: <1362311132-29561-6-git-send-email-arend@broadcom.com> (sfid-20130303_124611_530276_DB95CBBF)
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
	 <1362311132-29561-6-git-send-email-arend@broadcom.com>
	 (sfid-20130303_124611_530276_DB95CBBF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-03-03 at 12:45 +0100, Arend van Spriel wrote:
> The workaround is only needed when auth_type is automatic AND there is
> no WPA or RSN information element provided by cfg80211.

Does this really actually happen? Why would wpa_s select automatic when
it knows it's going to be open?

johannes

