Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:47982 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbbENMd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 08:33:29 -0400
Date: Thu, 14 May 2015 22:33:05 +1000
From: James Cameron <quozl@laptop.org>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, liuzy@marvell.com
Subject: Re: [PATCH] mwifiex: reduce severity of debug messages for mgmt rx
Message-ID: <20150514123305.GA9984@us.netrek.org> (sfid-20150514_143332_643922_6032B2A1)
References: <1431613651-9049-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431613651-9049-1-git-send-email-patila@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2015 at 07:57:31PM +0530, Avinash Patil wrote:
> This would ensure dmesg logs are not spammed with "unknown mgmt frame
> subtype" messages.

"subtype"

> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
> index 3c0b3c1..fd8ef3c 100644
> --- a/drivers/net/wireless/mwifiex/util.c
> +++ b/drivers/net/wireless/mwifiex/util.c
> @@ -350,7 +350,7 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
>  		}
>  		break;
>  	default:
> -		mwifiex_dbg(priv->adapter, ERROR,
> +		mwifiex_dbg(priv->adapter, INFO,
>  			    "unknown mgmt frame subytpe %#x\n", stype);

"subytpe" != "subtype"

An opportunity there.  ;-)

-- 
James Cameron
http://quozl.linux.org.au/
