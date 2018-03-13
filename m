Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:38146 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751679AbeCMHa7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 03:30:59 -0400
Date: Tue, 13 Mar 2018 13:00:51 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: <hariprasath.elango@gmail.com>, <linux-kernel@vger.kernel.org>
CC: <aditya.shankar@microchip.com>, <vbabu3@visteon.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCHv2] staging: wilc1000: use pre-defined macro
 is_broadcast_ether_addr
Message-ID: <20180313130051.43b087dd@ajaysk-VirtualBox> (sfid-20180313_083114_574157_6A096C54)
In-Reply-To: <20180312093903.9147-1-hariprasath.elango@gmail.com>
References: <20180312093903.9147-1-hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>

On Mon, 12 Mar 2018 15:09:03 +0530
<hariprasath.elango@gmail.com> wrote:

> From: HariPrasath Elango <hariprasath.elango@gmail.com>
>

Please avoid use of 'From' tag specially when there is only one
'Signed-off-by' tag and its same.

> Use the kernel pre-defined macro is_broadcast_ether_addr() instead of
> doing a memcmp here.
> 
> Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> ---

Regards,
Ajay
