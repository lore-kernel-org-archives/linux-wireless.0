Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36750 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085Ab0D3Ud4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 16:33:56 -0400
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv4 0/2] mac80211: cfg80211: dynamic ps timeout based on pm-qos
References: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 29 Apr 2010 16:45:29 +0300
In-Reply-To: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com> (Juuso Oikarinen's message of "Wed\, 21 Apr 2010 14\:47\:36 +0300")
Message-ID: <87633al6di.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> These patches propose a way to adjust the dynamic ps timeout in the
> mac80211 based on the pm-qos network latency value. This allows user
> space to influence the level of power saving performed by the
> mac80211.
>
> v4 of these patches change the way pm qos network latency ranges
> converted to dynamic ps timeout values a little bit saner. Unlike
> the previous set of patches, now the latancy values make sense in a
> wider scope than this ps timeout thing only. I hope this makes them
> somewhat more future-proof.

This looks very good now. Bonus points for adding the comment about
the two second value!

Thank you for implementing this.

-- 
Kalle Valo
