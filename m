Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:46681 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755630AbeASM4X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 07:56:23 -0500
Subject: Re: [PATCH 04/14] staging: wilc1000: rename
 host_int_ParseJoinBssParam() and it's variable using camelCase
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <ganesh.krishna@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
 <1516281432-7724-5-git-send-email-ajay.kathat@microchip.com>
 <63fc190a-15cd-3c7f-21d0-e726bdff8283@microchip.com>
 <20180119124417.5upkxkhfrk7om23s@mwanda>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <6c77d217-eb5e-9d5a-f64b-567bb55c8108@microchip.com> (sfid-20180119_135700_498243_121F33B2)
Date: Fri, 19 Jan 2018 14:56:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180119124417.5upkxkhfrk7om23s@mwanda>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 19.01.2018 14:44, Dan Carpenter wrote:
> On Fri, Jan 19, 2018 at 01:20:00PM +0200, Claudiu Beznea wrote:
>> It is hard to review this. Anyway, Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>>
> 
> I have a script I use.  It's sort of hacky, but it's a time saver.  I've
> attached it.
> 
> To review this one, I do `cat <email.txt> | rename_rev.pl -a`

Good do have it!

Thanks,
Claudiu Beznea
> 
> regards,
> dan carpenter
> 
