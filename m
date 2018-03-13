Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:40261 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbeCMHnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 03:43:12 -0400
Date: Tue, 13 Mar 2018 13:13:04 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: <hariprasath.elango@gmail.com>, <linux-kernel@vger.kernel.org>
CC: <aditya.shankar@microchip.com>, <vbabu3@visteon.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: wilc1000: use kmemdup instead of kmalloc and
 memcpy
Message-ID: <20180313131304.47d457e3@ajaysk-VirtualBox> (sfid-20180313_084327_491697_596DC594)
In-Reply-To: <20180313062049.6200-1-hariprasath.elango@gmail.com>
References: <20180313062049.6200-1-hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 Mar 2018 11:50:48 +0530
<hariprasath.elango@gmail.com> wrote:

> From: HariPrasath Elango <hariprasath.elango@gmail.com>
> 
> Kmalloc followed by memcpy can be replaced by kmemdup.
> 
> Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>

Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>


Regards,
Ajay
