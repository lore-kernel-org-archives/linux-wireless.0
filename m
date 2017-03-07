Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:29816 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933197AbdCGRt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 12:49:58 -0500
Date: Tue, 7 Mar 2017 20:24:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Ghittino <aghittino@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH] staging: wilc1000: Fix sparse warnings incorrect type
 assignment
Message-ID: <20170307172438.GI4171@mwanda> (sfid-20170307_185057_418807_7CCBF7EE)
References: <20170306211106.GA9885@myhd3>
 <20170307172304.GH4171@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307172304.GH4171@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 07, 2017 at 08:23:04PM +0300, Dan Carpenter wrote:
> This commit doesn't tell me if you though about what you are doing at
> all.  We get so many commits where people just randomly do random endian
> things...  Did you think about this?  Could you resend with a better
> commit message?
> 

The commit message should say what the user visible effects of this
bug fix are going to be.

regards,
dan carpenter
