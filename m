Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34991 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbFZM23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 08:28:29 -0400
Date: Fri, 26 Jun 2015 14:34:33 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: Sunil Shahu <shshahu@gmail.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: host_interface: add spaces around '='
Message-ID: <20150626123430.GA23122@goodgumbo.baconseed.org> (sfid-20150626_142835_035603_28A6679E)
References: <1434981181-9822-1-git-send-email-shshahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434981181-9822-1-git-send-email-shshahu@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 22, 2015 at 07:23:01PM +0530, Sunil Shahu wrote:
> Fix coding style error by placing spaces around '=' as suggested by
> checkpatch.pl script.
> 
> Signed-off-by: Sunil Shahu <shshahu@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 6b10bbb..d1fe73d 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -7945,8 +7945,8 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
>  	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_IPADDRESS;
>  
>  	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
> -	strHostIFmsg.drvHandler=hWFIDrv;
> -	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx= idx;
> +	strHostIFmsg.drvHandler = hWFIDrv;
> +	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
>  
>  	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
>  	if (s32Error) {
> -- 
> 1.9.1
> 

Appliess cleanly on staging-testing. Removes all checkpatch ERRORS related to
spaces placing in that file.

Reviewed-by: Luis de Bethencourt <luis@debethencourt.com>
