Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64691 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab2BSVTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 16:19:49 -0500
Received: by iacb35 with SMTP id b35so6719632iac.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 13:19:49 -0800 (PST)
Message-ID: <4F416772.5030703@lwfinger.net> (sfid-20120219_221953_507145_9476D4FC)
Date: Sun, 19 Feb 2012 15:19:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Attila Fazekas <turul64@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
References: <CAFmNhL=zp66TRZvi0e=05zJuFjm=pon1gKHXJYN6_uUs_erm4g@mail.gmail.com>
In-Reply-To: <CAFmNhL=zp66TRZvi0e=05zJuFjm=pon1gKHXJYN6_uUs_erm4g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2012 01:54 PM, Attila Fazekas wrote:
> Add AD-HOC support to the rtl8187 based on the rtl8180 source
>
> Signed-off-by: Attila Fazekas<turul64@gmail.com>
> ---
> diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> index 638fbef..f8f9186 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> @@ -232,6 +232,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
> struct sk_buff *skb)
>   {
>   	struct rtl8187_priv *priv = dev->priv;
>   	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct ieee80211_hdr *tx_hdr = 	(struct ieee80211_hdr *)(skb->data);
>   	unsigned int ep;
>   	void *buf;
>   	struct urb *urb;
> @@ -249,7 +250,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
> struct sk_buff *skb)

This patch was mangled by your mailer. See how the line above is wrapped? In 
addition, the tabs seem to have been replaced by spaces.

To test what works, you should mail a patch to yourself and see if the version 
extracted from your mailer still applies.

Larry
