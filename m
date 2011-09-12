Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34439 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab1ILNPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 09:15:33 -0400
Received: by pzk37 with SMTP id 37so6787088pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 06:15:32 -0700 (PDT)
Date: Mon, 12 Sep 2011 16:13:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/20] staging: brcm80211: removed unused
 encryption/security functionality
Message-ID: <20110912131311.GI14370@shale.localdomain> (sfid-20110912_151536_617286_A93A242A)
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
 <1315822504-24210-11-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315822504-24210-11-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 12, 2011 at 12:14:54PM +0200, Roland Vossen wrote:
> -#define BRCMS_PORTOPEN(cfg) \
> -	(((cfg)->WPA_auth != WPA_AUTH_DISABLED && WSEC_ENABLED((cfg)->wsec)) ? \
> -	(cfg)->wsec_portopen : true)
> +#define BRCMS_PORTOPEN(cfg) true
>  

We could just delete BRCMS_PORTOPEN(), yes?

regards,
dan carpenter

