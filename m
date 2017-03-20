Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:42005 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753837AbdCTLr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 07:47:27 -0400
Date: Mon, 20 Mar 2017 14:45:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jacob Zachariah <jacob.zac316@gmail.com>
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Fix sparse warning in
 wilc_wfi_cfgoperations.c
Message-ID: <20170320114547.GD4395@mwanda> (sfid-20170320_124920_039186_43FF92B8)
References: <1489990628-8665-1-git-send-email-jacob.zac316@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1489990628-8665-1-git-send-email-jacob.zac316@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 19, 2017 at 11:17:08PM -0700, Jacob Zachariah wrote:
> Fix the following warning reported by sparse:
> 
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51: warning: incorrect type in assignment (different base types)
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51:    expected unsigned short [unsigned] [assigned] [usertype] ht_capa_info
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51:    got restricted __le16 const [usertype] cap_info
> 

This is probably correct but there is another just a few lines down.
Fix that as well.

regards,
dan carpenter
