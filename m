Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOU0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 16:26:04 -0400
Date: Thu, 15 May 2014 13:29:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: vt6656: nsDMA_tx_packet Move pContext later
Message-ID: <20140515202922.GA2419@kroah.com> (sfid-20140515_222608_040193_5211168A)
References: <1398889875-3312-1-git-send-email-tvboxspy@gmail.com>
 <1398889875-3312-3-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1398889875-3312-3-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 30, 2014 at 09:31:14PM +0100, Malcolm Priestley wrote:
> call s_vGetFreeContext later in function skiping large
> chunk of code.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/rxtx.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)

Due to other changes in the tree, this patch doesn't apply :(
