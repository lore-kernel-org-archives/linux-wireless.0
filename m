Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f176.google.com ([209.85.210.176]:36381 "EHLO
        mail-wj0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761575AbcLWTiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Dec 2016 14:38:54 -0500
Received: by mail-wj0-f176.google.com with SMTP id c11so54094128wjx.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2016 11:38:54 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: fix spelling mistakes on "Ivalid"
To: Colin King <colin.king@canonical.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
References: <20161223004322.7300-1-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <291781bb-801c-0b73-0b60-8081f42c52b4@broadcom.com> (sfid-20161223_203916_446205_2E062172)
Date: Fri, 23 Dec 2016 20:38:51 +0100
MIME-Version: 1.0
In-Reply-To: <20161223004322.7300-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-12-2016 1:43, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fixes to spelling mistake "Ivalid" to "Invalid" in
> brcmf_err error messages.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 7ffc4ab..15eaf72 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -3971,7 +3971,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
>  			pval |= AES_ENABLED;
>  			break;
>  		default:
> -			brcmf_err("Ivalid unicast security info\n");
> +			brcmf_err("Invalid unicast security info\n");
>  		}
>  		offset++;
>  	}
> @@ -4015,7 +4015,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
>  			wpa_auth |= WPA2_AUTH_1X_SHA256;
>  			break;
>  		default:
> -			brcmf_err("Ivalid key mgmt info\n");
> +			brcmf_err("Invalid key mgmt info\n");
>  		}
>  		offset++;
>  	}
> 
