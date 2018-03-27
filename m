Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:39743 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbeC0Izz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:55:55 -0400
Subject: Re: [PATCH 00/11] staging: wilc1000: fix for checkpatch and handled
 malloc memory properly
To: Ajay Singh <ajay.kathat@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <venkateswara.kaja@microchip.com>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@microchip.com>, <aditya.shankar@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <20180321075116.bm6x3c53bahw3c2i@mwanda>
 <20180321145021.044f4536@ajaysk-VirtualBox>
 <53a25901-754c-bfe9-169e-d2ed4cb34583@microchip.com>
 <20180327125213.0594ff79@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <0546cfdf-8767-8309-2bf2-ab5ad96f2c27@microchip.com> (sfid-20180327_105600_416005_14B03F07)
Date: Tue, 27 Mar 2018 11:55:52 +0300
MIME-Version: 1.0
In-Reply-To: <20180327125213.0594ff79@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 27.03.2018 10:22, Ajay Singh wrote:
> 
> Please let me know, in case I have to rework and resubmit this patch
> series to make them into staging branch.
> 

As I suggested in patch 6, I prefer having the same format for
wilc_wfi_cfg_tx_vendor_spec() and wilc_wfi_cfg_parse_rx_vendor_spec(). I
think this could be achieved. To merge them I don't think would be feasible.

This series could go as is but I would like to see another future patch to
treat the format of wilc_wfi_cfg_tx_vendor_spec().

Thank you,
Claudiu

> Regards,
> Ajay
> 
