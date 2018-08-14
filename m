Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43546 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbeHNN5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 09:57:19 -0400
Date: Tue, 14 Aug 2018 16:40:28 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>,
        <linux-wireless@vger.kernel.org>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 2/5] staging: wilc1000: fixes for undefined reference to
 `__this_module' error
Message-ID: <20180814164028.5b8703aa@ajaysk-VirtualBox> (sfid-20180814_131040_229195_EC6F0CA4)
In-Reply-To: <20180814105621.hu3kpbxwz4kjc2o3@mwanda>
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
        <1534049265-5600-3-git-send-email-ajay.kathat@microchip.com>
        <20180812113555.GC25209@kroah.com>
        <20180812174852.2eecf7da@ajaysk-VirtualBox>
        <20180814105621.hu3kpbxwz4kjc2o3@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Tue, 14 Aug 2018 13:56:21 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Sun, Aug 12, 2018 at 05:48:52PM +0530, Ajay Singh wrote:
> > Yes, currently only code to read and writing for "wilc_debug_level"
> > exists.
> > 
> > The main purpose for this file was to configure(enable/disable)
> > specific level debug logs to print.
> >  
> 
> The kernel's dev_dbg() macros are really very clever.  You can enable
> them for one file or for a specific line or for a function.
> 

Thanks for the information.

I will explore these debug macros in future.

Regards,
Ajay
