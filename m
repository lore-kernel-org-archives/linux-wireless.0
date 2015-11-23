Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbbKWSb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:31:58 -0500
Subject: Re: [PATCH 4/4] staging: wilc1000: Fix typo in
 wilc_wfi_cfgoperations.c
To: Masanari Iida <standby24x7@gmail.com>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	austin.shin@atmel.com, johnny.kim@atmel.com,
	linux-wireless@vger.kernel.org
References: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
 <1448286080-14787-4-git-send-email-standby24x7@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <56535B9A.6000000@infradead.org> (sfid-20151123_193203_731983_504F053C)
Date: Mon, 23 Nov 2015 10:31:54 -0800
MIME-Version: 1.0
In-Reply-To: <1448286080-14787-4-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/15 05:41, Masanari Iida wrote:
> This patch fix some spelling typo in wilc_wfi_cfgoperations.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 34 +++++++++++------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 6f40522..ee09d56 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -1923,7 +1923,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
>  	/* Get WILC header */
>  	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
>  
> -	/* The packet offset field conain info about what type of managment frame */
> +	/* The packet offset field contain info about what type of management frame */

	                           contains

>  	/* we are dealing with and ack status */
>  	pkt_offset = GET_PKT_OFFSET(header);
>  
> @@ -2283,7 +2283,7 @@ static int mgmt_tx(struct wiphy *wiphy,
>  							if (u8P2Plocalrandom > u8P2Precvrandom)	{
>  								PRINT_D(GENERIC_DBG, "LOCAL WILL BE GO LocaRand=%02x RecvRand %02x\n", u8P2Plocalrandom, u8P2Precvrandom);
>  
> -								/*Search for the p2p information information element , after the Public action subtype theres a byte for teh dialog token, skip that*/
> +								/*Search for the p2p information information element , after the Public action subtype theres a byte for the dialog token, skip that*/

Please change "theres" to "there's" or "there is".

>  								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
>  									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(u8P2P_oui, &buf[i + 2], 4))) {
>  										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)


-- 
~Randy
