Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbIQEsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 00:48:18 -0400
Date: Wed, 16 Sep 2015 21:47:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aparna Karuthodi <kdasaparna@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: Added spaces
Message-ID: <20150917044741.GB10134@kroah.com> (sfid-20150917_064839_320957_8C00861F)
References: <1442428970-9091-1-git-send-email-kdasaparna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442428970-9091-1-git-send-email-kdasaparna@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2015 at 12:12:50AM +0530, Aparna Karuthodi wrote:
> Added spaces around '=' to remove coding style errors detected by
> checkpatch.The errors are given below:
> drivers/staging/wilc1000/host_interface.c:7951: ERROR: spaces required
> around that '=' (ctx:VxV)
> drivers/staging/wilc1000/host_interface.c:7952: ERROR: spaces required
> around that '=' (ctx:VxW)
> 
> Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c |    4 ++--
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
> 1.7.9.5

Does not apply to my tree :(
