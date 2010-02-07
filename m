Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:63405 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0BGODz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 09:03:55 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1145556eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 06:03:54 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH 09/10] rt2x00: remove get_tx_stats() mac80211 op
Date: Sun, 7 Feb 2010 15:03:46 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20100207082044.31474.48583.stgit@tikku> <20100207082153.31474.76058.stgit@tikku>
In-Reply-To: <20100207082153.31474.76058.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002071503.46588.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 February 2010, Kalle Valo wrote:
> get_tx_stats() will be removed from mac80211.
> 
> Compile-tested only.
> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
