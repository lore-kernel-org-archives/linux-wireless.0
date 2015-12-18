Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbLSAoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:30 -0500
Date: Fri, 18 Dec 2015 14:47:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: remove new line around else and braces
Message-ID: <20151218224715.GA14595@kroah.com> (sfid-20151219_014436_071604_976F897B)
References: <1447010328-5661-1-git-send-email-panayiotis.tembriotis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447010328-5661-1-git-send-email-panayiotis.tembriotis@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 08, 2015 at 09:18:48PM +0200, Panayiotis Tembriotis wrote:
> Remove excess new line characters as suggested by checkpatch.pl:
> ERROR: else should follow close brace '}'
> ERROR: that open brace { should be on the previous line
> 
> Signed-off-by: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Does not apply against my latest tree :(
