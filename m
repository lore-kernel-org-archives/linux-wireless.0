Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbbFRETx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 00:19:53 -0400
Date: Wed, 17 Jun 2015 21:19:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sunghoon Cho <ywhsbliss@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com
Subject: Re: [PATCH 2/5] staging: wilc1000: remove the warnings on multiple
 blank line uses.
Message-ID: <20150618041951.GA10740@kroah.com> (sfid-20150618_061955_324768_BA76D726)
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
 <8780894482d8ada4d46da9e008945a5bd03e12fe.1434526056.git.ywhsbliss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8780894482d8ada4d46da9e008945a5bd03e12fe.1434526056.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 04:28:52PM +0900, Sunghoon Cho wrote:
> This patch removes the warnings reported by checkpatch.pl regarding
> the multiple blank line.
> 
> Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan_if.h | 12 ------------
>  1 file changed, 12 deletions(-)

Doesn't apply :(

Please rebase all of these and resend.

thanks,

greg k-h
