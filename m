Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54383 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1AXUT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:19:26 -0500
Subject: Re: [PATCH v2] wl12xx: Add channel 14 to list of supported 2ghz
 channels
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295379592-6223-1-git-send-email-arik@wizery.com>
References: <1295379592-6223-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 22:19:35 +0200
Message-ID: <1295900375.2063.4.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 20:39 +0100, Arik Nemtsov wrote:
> Channel 14 is only supported in Japan (JP country code in).
> The FW limits tranmissions to CCK only on this channel.
> 
> Tested in both STA and AP modes to work correctly.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied to wl12xx.  Thank you!

-- 
Cheers,
Luca.

