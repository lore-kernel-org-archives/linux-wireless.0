Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbIQEsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 00:48:05 -0400
Date: Wed, 16 Sep 2015 21:47:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aparna Karuthodi <kdasaparna@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: Added new lines
Message-ID: <20150917044734.GA10134@kroah.com> (sfid-20150917_064844_212485_145FE34E)
References: <1442405562-6115-1-git-send-email-kdasaparna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442405562-6115-1-git-send-email-kdasaparna@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2015 at 05:42:42PM +0530, Aparna Karuthodi wrote:
> Added new lines after declarations for removing coding style warnings
> detected by checkpatch.The warnings are given below:
> 
> 1561: WARNING: Missing a blank line after declarations
> 1551: WARNING: Missing a blank line after declarations
> 1329: WARNING: Missing a blank line after declarations
> 1213: WARNING: Missing a blank line after declarations
> 1158: WARNING: Missing a blank line after declarations
> 1104: WARNING: Missing a blank line after declarations
> 675: WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c |    7 +++++++
>  1 file changed, 7 insertions(+)

Does not apply to my tree :(
