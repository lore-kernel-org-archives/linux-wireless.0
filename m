Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12315 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752774AbeC0NQa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:16:30 -0400
Date: Tue, 27 Mar 2018 18:46:22 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 00/11] staging: wilc1000: fix for checkpatch and handled
 malloc memory properly
Message-ID: <20180327184622.7f9dd976@ajaysk-VirtualBox> (sfid-20180327_152223_704859_80BB6203)
In-Reply-To: <0546cfdf-8767-8309-2bf2-ab5ad96f2c27@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <20180321075116.bm6x3c53bahw3c2i@mwanda>
 <20180321145021.044f4536@ajaysk-VirtualBox>
 <53a25901-754c-bfe9-169e-d2ed4cb34583@microchip.com>
 <20180327125213.0594ff79@ajaysk-VirtualBox>
 <0546cfdf-8767-8309-2bf2-ab5ad96f2c27@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Claudiu,

On Tue, 27 Mar 2018 11:55:52 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 27.03.2018 10:22, Ajay Singh wrote:
> > 
> > Please let me know, in case I have to rework and resubmit this patch
> > series to make them into staging branch.
> >   
> 
> As I suggested in patch 6, I prefer having the same format for
> wilc_wfi_cfg_tx_vendor_spec() and wilc_wfi_cfg_parse_rx_vendor_spec(). I
> think this could be achieved. To merge them I don't think would be feasible.
> 
> This series could go as is but I would like to see another future patch to
> treat the format of wilc_wfi_cfg_tx_vendor_spec().
> 

Sure, I had noted the review comments received for patch#6 & patch#1. I
will include the code modification in another future patches to handle it.


Regards,
Ajay
