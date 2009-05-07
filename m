Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38120 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761364AbZEGNyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 09:54:17 -0400
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1241696104.27208.2.camel@johannes.local>
References: <1241677107.2918.4.camel@localhost.localdomain>
	 <1241696104.27208.2.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 07 May 2009 06:53:57 -0700
Message-Id: <1241704437.4903.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Copying Wey-Yi, but I think she's aware of this? It's definitely a
> driver issue. I _suspect_, but am not sure, that the driver kills the
> aggregation session when we disassoc or something and we only tell it
> about the STA removal after that, when it already killed the STA. Thus
> it would be a consequence of iwlwifi not implementing a proper
> sta_notify() callback.

I don't see it with nl80211 driver, but that might be pure luck.

Regards

Marcel


