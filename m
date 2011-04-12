Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58394 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab1DLXAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 19:00:31 -0400
Date: Tue, 12 Apr 2011 16:28:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mwl8k: Fix checkpatch.pl and sparse warnings and errors
Message-ID: <20110412202831.GC24309@tuxdriver.com>
References: <20110408185529.GA26751@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110408185529.GA26751@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 09, 2011 at 12:25:37AM +0530, Yogesh Ashok Powar wrote:
> Fix checkpatch errors and warnings comprising of indent errors, spaces and
> __packed warnings. Also fix 'make C = 2' warnings.
> 
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> ---
>  drivers/net/wireless/mwl8k.c |   27 +++++++++++++--------------
>  1 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index 8913180..fb472f4 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -701,7 +701,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
>  			       "helper image\n", pci_name(priv->pdev));
>  			return rc;
>  		}
> -		msleep(5);
> +		msleep(20);
>  
>  		rc = mwl8k_feed_fw_image(priv, fw->data, fw->size);
>  	} else {

Is this an indent error, a space, or a __packed warning??

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
