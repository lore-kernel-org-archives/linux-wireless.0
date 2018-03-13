Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11901 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbeCMHlV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 03:41:21 -0400
Date: Tue, 13 Mar 2018 13:11:14 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: <hariprasath.elango@gmail.com>, <linux-kernel@vger.kernel.org>
CC: <aditya.shankar@microchip.com>, <vbabu3@visteon.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: wilc1000: Destroy mutex object in
 deinitialization
Message-ID: <20180313131114.13ff73ce@ajaysk-VirtualBox> (sfid-20180313_084137_048644_B63425ED)
In-Reply-To: <20180312131950.12854-1-hariprasath.elango@gmail.com>
References: <20180312131950.12854-1-hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 12 Mar 2018 18:49:49 +0530
<hariprasath.elango@gmail.com> wrote:

> From: HariPrasath Elango <hariprasath.elango@gmail.com>
> 
> Destroy the mutex object that is initialized in wlan_init_locks()
> 
> Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>

Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>


Regards,
Ajay
