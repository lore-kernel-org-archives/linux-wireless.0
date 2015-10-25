Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbJYTM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 15:12:29 -0400
Date: Mon, 26 Oct 2015 04:12:25 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Punit Vara <punitvara@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Staging: wilc1000: Remove comparision of field
 address to NULL
Message-ID: <20151025191225.GA23928@kroah.com> (sfid-20151025_201324_980701_62BC9189)
References: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
 <1445725885-25995-3-git-send-email-punitvara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445725885-25995-3-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 25, 2015 at 04:01:24AM +0530, Punit Vara wrote:
> This is patch to the linux_wlan file that fixes up following error
> reported by coccicheck :
> 
> ERROR: test of a variable/field address
> 
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Does not apply to my tree anymore, I think someone else already did this
:(
