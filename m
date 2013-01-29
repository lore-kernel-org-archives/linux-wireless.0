Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3A2K5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 05:57:35 -0500
Message-ID: <1359457078.8108.4.camel@jlt4.sipsolutions.net> (sfid-20130129_115740_522415_928D53BA)
Subject: Re: [RFC/RFT] mac80211: use macaddr vif parameter for P2P_DEVICE
 creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Tue, 29 Jan 2013 11:57:58 +0100
In-Reply-To: <1359382746-26322-1-git-send-email-arend@broadcom.com>
References: <1359382746-26322-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-28 at 15:19 +0100, Arend van Spriel wrote:
> This patch is a follow-up of:
> 
> commit 1c18f1452a772dfe884ed25677bddb3ecaf9c43a
> Author: Arend van Spriel <arend@broadcom.com>
> Date:   Tue Jan 8 10:17:27 2013 +0100
> 
>     nl80211: allow user-space to set address for P2P_DEVICE
> 
> The address of the wdev is determined by the macaddr parameter
> when it is not a zero ethernet address. Otherwise, the permanent
> address as determined by ieee80211_assign_perm_addr() is used.
> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Johannes,
> 
> Here a mac80211 change to take the user-space provided mac address into
> account. Not sure if that is sufficient. Tested P2P device vif creation using
> iw with mac80211_hwsim:

Looks fine to me, yeah.

johannes

