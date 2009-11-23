Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49790 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZKWS3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 13:29:05 -0500
Received: by ewy19 with SMTP id 19so2134520ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 10:29:11 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 4/6] rt2x00: Fix typo (lengt --> length) in rt2x00queue.c
Date: Mon, 23 Nov 2009 19:29:08 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> <1258960565-26736-4-git-send-email-gwingerde@gmail.com> <1258960565-26736-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911231929.08635.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009, Gertjan van Wingerde wrote:
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index eaedee8..32d4aea 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -162,10 +162,10 @@ void rt2x00queue_align_frame(struct sk_buff *skb)
>  	skb_trim(skb, frame_length);
>  }
>  
> -void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_lengt)
> +void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_length)
>  {
>  	unsigned int frame_length = skb->len;
> -	unsigned int align = ALIGN_SIZE(skb, header_lengt);
> +	unsigned int align = ALIGN_SIZE(skb, header_length);
>  
>  	if (!align)
>  		return;


