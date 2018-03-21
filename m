Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:27940 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752368AbeCUOEd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 10:04:33 -0400
Subject: Re: [PATCH 00/11] staging: wilc1000: fix for checkpatch and handled
 malloc memory properly
To: Ajay Singh <ajay.kathat@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <20180321075116.bm6x3c53bahw3c2i@mwanda>
 <20180321145021.044f4536@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <53a25901-754c-bfe9-169e-d2ed4cb34583@microchip.com> (sfid-20180321_150446_045488_C2EDB9B4)
Date: Wed, 21 Mar 2018 16:04:28 +0200
MIME-Version: 1.0
In-Reply-To: <20180321145021.044f4536@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 6 may be reworked a bit. Other than this:

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 21.03.2018 11:20, Ajay Singh wrote:
> Hi Dan,
> 
> On Wed, 21 Mar 2018 10:51:16 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
>> These look good.  I've reviewed them all.
>>
>> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Thanks for reviewing all the patches.
> 
>>
>> I had some small process complaints but it doesn't make life easier for
>> me if you resend them and I have to review everything twice.... :P
>>
> 
> In future patches, I will take care as per your suggestions. Instead of
> resubmitting this patch series, I will include the additional changes
> required for [PATCH 01/11] in separate patch series.
> 
> 
> Regards,
> Ajay
> 
