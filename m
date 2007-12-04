Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:32790 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXLDWmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 17:42:49 -0500
Message-ID: <4755D7E7.3060603@garzik.org> (sfid-20071204_224252_048983_EACC7455)
Date: Tue, 04 Dec 2007 17:42:47 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: correct "skb_buff" typo
References: <1196807075-28518-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1196807075-28518-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Jeff,
> 
> I found this one when pushing the latest round of wireless bits
> into rawhide.  Wanna just go ahead and apply it to netdev-2.6#upstream?
> 
> John
> 
>  drivers/net/wireless/rt2x00/rt2x00lib.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 0bf10ff..108488d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -91,7 +91,7 @@ static inline void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
>  }
>  
>  static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
> -					  struct skb_buff *skb)
> +					  struct sk_buff *skb)

applied


