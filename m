Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46052 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbeHNN4v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 09:56:51 -0400
Received: by mail-qt0-f193.google.com with SMTP id y5-v6so20571982qti.12
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 04:10:10 -0700 (PDT)
Subject: Re: [PATCH 2/5] staging: wilc1000: fixes for undefined reference to
 `__this_module' error
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Ajay Singh <ajay.kathat@microchip.com>
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
 <1534049265-5600-3-git-send-email-ajay.kathat@microchip.com>
 <20180812113555.GC25209@kroah.com>
 <20180812174852.2eecf7da@ajaysk-VirtualBox>
 <20180814105621.hu3kpbxwz4kjc2o3@mwanda>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, linux-wireless@vger.kernel.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B72B88F.9060803@broadcom.com> (sfid-20180814_131013_067044_F3ACF50B)
Date: Tue, 14 Aug 2018 13:10:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180814105621.hu3kpbxwz4kjc2o3@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/14/2018 12:56 PM, Dan Carpenter wrote:
> On Sun, Aug 12, 2018 at 05:48:52PM +0530, Ajay Singh wrote:
>> Yes, currently only code to read and writing for "wilc_debug_level"
>> exists.
>>
>> The main purpose for this file was to configure(enable/disable)
>> specific level debug logs to print.
>>
>
> The kernel's dev_dbg() macros are really very clever.  You can enable
> them for one file or for a specific line or for a function.

Provided you have CONFIG_DYNAMIC_DEBUG selected.

Gr. AvS
