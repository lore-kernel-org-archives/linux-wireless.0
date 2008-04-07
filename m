Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:44261 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYDGTWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 15:22:09 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] nl80211: fix STA AID bug
Date: Mon, 7 Apr 2008 21:22:05 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Bas Hulsken <bhulsken@zonnet.nl>
References: <1207571746.12481.2.camel@johannes.berg>
In-Reply-To: <1207571746.12481.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804072122.06433.chunkeey@web.de> (sfid-20080407_202224_189847_157E4234)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 April 2008 14:35:46 Johannes Berg wrote:
> This fixes the STA AID setting and actually makes hostapd/mac80211
> work properly in presence of power-saving stations.
>
Indeed... I have lots of problems with power-saving stations and p54-ap.
(OT: no, it's not because of your patch.. it's the device/fw. grrrrr!)

Regards,
	Chr
