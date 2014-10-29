Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934105AbaJ2PmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:04 -0400
Date: Wed, 29 Oct 2014 17:15:59 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net
Subject: Re: [PATCH 01/48] staging: vt6655: s_cbFillTxBufHead remove unused
 parameters
Message-ID: <20141029091559.GA5035@kroah.com> (sfid-20141029_164722_842966_62EEE616)
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
 <1414226426-5811-2-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414226426-5811-2-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 25, 2014 at 09:39:39AM +0100, Malcolm Priestley wrote:
> Remove the following parameters
> PSEthernetHeader psEthHeader
> PSKeyItem pTransmitKey
> bool bNeedEncrypt
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6655/rxtx.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

I think this causes a build error, but I'm not quite sure, as I probably
messed up the merge.  Can you refresh this series and resend?

thanks,

greg k-h
