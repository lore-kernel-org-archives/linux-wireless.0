Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:43083 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1AGAd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:33:59 -0500
Received: by pxi15 with SMTP id 15so2993961pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 16:33:59 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19750.24410.495583.789895@gargle.gargle.HOWL>
Date: Fri, 7 Jan 2011 06:03:30 +0530
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC v2] cfg80211: Add HT BSS attributes
In-Reply-To: <19749.37051.292861.996698@gargle.gargle.HOWL>
References: <19749.32067.311517.479374@gargle.gargle.HOWL>
	<19749.37051.292861.996698@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resend to list).

Sujith wrote:
> Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > Add two new per-BSS attributes to allow configuration of
> > HT capabilites and operational parameters by hostapd.
> 
> Ok, looks like this is not needed after all.
> When operating in AP mode, an associated station's HT caps is
> notified to the driver through sta_add() anyway.
> 
> The main motive for this patch was that ath9k_htc required the
> HT params of the current BSS and it turns out that the firmware
> doesn't do anything with the information. :)
> 
> Sujith
