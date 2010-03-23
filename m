Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:50725 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0CWQYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 12:24:03 -0400
Received: by pxi14 with SMTP id 14so4146363pxi.15
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 09:24:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269327754-995-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
	<1269327754-995-2-git-send-email-juuso.oikarinen@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Mar 2010 09:23:42 -0700
Message-ID: <43e72e891003230923r60522440vff7c1db26300ca91@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: Add connection quality monitoring support
	to nl80211
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	luciano.coelho@nokia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 12:02 AM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:

> + * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm

I still don't get what this particular value is for, despite this kdoc entry.

  Luis
