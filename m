Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:43535 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZKHNol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:44:41 -0500
Received: by ewy3 with SMTP id 3so2373818ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:44:46 -0800 (PST)
Message-ID: <4AF6CB4C.4050605@gmail.com>
Date: Sun, 08 Nov 2009 14:44:44 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	rt2x00 Core Developers List <coredev@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: Remove deprecated ieee80211_rx_status->qual usage
References: <200911081437.49121.IvDoorn@gmail.com>
In-Reply-To: <200911081437.49121.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 14:37, Ivo van Doorn wrote:
> ieee80211_rx_status->qual has been marked deprecated.
> This allows us to remove several functions and fields which
> were used to calculate a reasonable value for it.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
