Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:11955 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753081AbeB0NXt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:23:49 -0500
Date: Tue, 27 Feb 2018 18:53:40 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 8/8] staging: wilc1000: fix open parenthesis mismatch
 issue in wilc_wlan_cfg_set()
Message-ID: <20180227185340.485b3e6b@ajaysk-VirtualBox> (sfid-20180227_142355_094477_E6B8EC36)
In-Reply-To: <20180227094140.tad4smuvfvkzmx6m@mwanda>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
        <1519662722-15761-9-git-send-email-ajay.kathat@microchip.com>
        <20180227094140.tad4smuvfvkzmx6m@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Tue, 27 Feb 2018 12:41:40 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The first 5 patches are good, but the last 3 are not OK.

Thanks for your review comments. 
I will resubmit the patch series by only including first 5 patches. I
will recheck the last 3 patches and submit them separately.

> 
> Normally "tmp" is used as an iterator pointer or something along those
> lines.  For example, here is a good use of "tmp".
> 
> 	tmp = left;
> 	left = right;
> 	right = tmp;
> 
> In this example, you want to store a pointer temporarily, so what else
> are you going to call it besides "tmp"?  The name "tmp" doesn't mean
> "I want a short name and I'm too lazy to think of one".
> 

Sure, I will take care of this point in subsequent patches.

Regards,
Ajay
