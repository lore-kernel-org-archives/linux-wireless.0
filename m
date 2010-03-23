Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49884 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0CWHOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 03:14:06 -0400
Subject: Re: [PATCH 2/2] mac80211: Add support for connection quality
 monitoring
From: Marcel Holtmann <marcel@holtmann.org>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	luciano.coelho@nokia.com
In-Reply-To: <1269327754-995-3-git-send-email-juuso.oikarinen@nokia.com>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269327754-995-3-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 00:13:56 -0700
Message-ID: <1269328436.11714.56.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Juuso,

> Add support for the set_cqm_config op. This op function configures the
> requested connection quality monitor rssi threshold and rssi hysteresis
> values to the hardware  if the hardware supports
> IEEE80211_HW_SUPPORTS_CQM.
> 
> For unsupporting hardware, currently -EOPNOTSUPP is returned, so the mac80211
> is currently not doing connection quality monitoring on the host. This could be
> added later, if needed.

I think you mean "For unsupported hardware, ..." ;)

Regards

Marcel


