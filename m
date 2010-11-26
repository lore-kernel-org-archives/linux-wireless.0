Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:35130 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0KZNn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 08:43:56 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAQDhtPc000727
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 15:43:55 +0200
Subject: Re: [PATCH] wl1271: Fix setting of the hardware connection
 monitoring probe-req template
From: Luciano Coelho <luciano.coelho@nokia.com>
To: juuso.oikarinen@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290579417-1382-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1290579417-1382-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1290579417-1382-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 15:44:06 +0200
Message-ID: <1290779046.15341.14.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 08:16 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The probe-request template used in the hardware connection monitoring feature
> thus far has been an empty one, without the SSID IE and without supported rate
> IEs. This causes problems with some AP's.
> 
> Additionally, after connected scans, the template for connection maintenance
> would remain to be the one last used for scanning - potentially incorrect.
> 
> Fix these by getting a pre-filled directed probe-request template for the
> associated-to AP from mac80211.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Applied and pushed, thanks!


-- 
Cheers,
Luca.

