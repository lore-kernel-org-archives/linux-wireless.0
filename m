Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbbJUBqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 21:46:05 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 05/16] rtl8xxxu: Unbreak a user-visible string
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-6-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 21:46:03 -0400
In-Reply-To: <1445323546-12807-6-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:35 +0200")
Message-ID: <wrfjk2qhvvs4.fsf@redhat.com> (sfid-20151021_034609_878383_EEFFA7AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index cfb18db..e892fde 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -2002,8 +2002,8 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
>  		/* We have 8 bits to indicate validity */
>  		map_addr = offset * 8;
>  		if (map_addr >= EFUSE_MAP_LEN_8723A) {
> -			dev_warn(dev, "%s: Illegal map_addr (%04x), "
> -				 "efuse corrupt!\n",
> +			dev_warn(dev,
> +				 "%s: Illegal map_addr (%04x), efuse corrupt!\n",

This would make the line longer than 80 characters - so no.

NAK

Jes
