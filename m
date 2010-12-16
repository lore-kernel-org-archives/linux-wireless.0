Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55989 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LPMYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:24:22 -0500
Received: by iwn9 with SMTP id 9so3225596iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:24:22 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19722.1212.579544.451006@gargle.gargle.HOWL>
Date: Thu, 16 Dec 2010 17:53:24 +0530
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: Sujith <m.sujith@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] ath9k_htc : Update txrate status to mac80211
In-Reply-To: <4D0A012E.3090408@atheros.com>
References: <1292499588-11636-1-git-send-email-mshajakhan@atheros.com>
	<19721.65246.410283.55163@gargle.gargle.HOWL>
	<4D0A012E.3090408@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi wrote:
> This patch just takes care for displaying the txrate and appropriately 
> sets mac80211 rate control flags,but completely ignores long retries.I 
> had tested it  , except retries the MCS index , txrate in userspace 
> matches with the txrate reported in debug statistics.
>      Is there chance of any possible fix for this ?

Not really, unless the FW is changed so that it can report TX status.

Sujith
