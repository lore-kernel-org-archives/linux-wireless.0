Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbeB0NcA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:32:00 -0500
Date: Tue, 27 Feb 2018 16:26:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 8/8] staging: wilc1000: fix open parenthesis mismatch
 issue in wilc_wlan_cfg_set()
Message-ID: <20180227132647.ka7guguoojolcryg@mwanda> (sfid-20180227_143218_559217_32501DBE)
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
 <1519662722-15761-9-git-send-email-ajay.kathat@microchip.com>
 <20180227094140.tad4smuvfvkzmx6m@mwanda>
 <20180227185340.485b3e6b@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180227185340.485b3e6b@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 06:53:40PM +0530, Ajay Singh wrote:
> Hi Dan,
> 
> On Tue, 27 Feb 2018 12:41:40 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > The first 5 patches are good, but the last 3 are not OK.
> 
> Thanks for your review comments. 
> I will resubmit the patch series by only including first 5 patches. I
> will recheck the last 3 patches and submit them separately.
> 

Greg can probably just apply the first 5 as-is.  No need to resend.

regards,
dan carpenter
