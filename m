Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:41259 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752372AbcIVMeC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 08:34:02 -0400
From: <Ganesh.Krishna@microchip.com>
To: <gregkh@linuxfoundation.org>, <nicolas.ferre@atmel.com>
CC: <linux-wireless@vger.kernel.org>, <Aditya.Shankar@microchip.com>,
        <luisbg@osg.samsung.com>
Subject: RE: staging: wilc1000: kernel Oops while opening the device
Date: Thu, 22 Sep 2016 12:34:01 +0000
Message-ID: <65355EED85AFFB41B861AC69A1D0893DCADB8ACF@CHN-SV-EXMX03.mchp-main.com> (sfid-20160922_143406_314196_B4EB91C9)
References: <c12338f5-0a50-bb55-0b83-0fa705237cf8@atmel.com>
 <20160919134201.GA25769@kroah.com>
In-Reply-To: <20160919134201.GA25769@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>-----Original Message-----
>From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org] 
>Sent: Monday, September 19, 2016 7:12 PM
>To: Nicolas Ferre
>Cc: linux-wireless@vger.kernel.org; Aditya Shankar - I16078; Ganesh Krishna - I00112; luisbg@osg.samsung.com
>Subject: Re: staging: wilc1000: kernel Oops while opening the device
>
>On Mon, Sep 19, 2016 at 02:06:02PM +0200, Nicolas Ferre wrote:
>> Hi all,
>> 
>> While using the wilc1000 driver with latest 4.8-rc7, I have 
>> difficulties to open the device and actually use it as I have this 
>> kernel Oops right after the loading of the firmware (wilc1003_firmware.bin).
>> 
>> If I revert back the driver to its 
>> b9811891a9f60ca9c314dcab3244c65930c4cf37 state, it works okay. I did 
>> this because I tend to think that it might be related to the latest move on this driver to "completion" or "work queues".
>> It seems to be a regression from 4.7.
>
>Ick, not good at all.
>
>Any chance you can run 'git bisect' to see if you can find the offending patch?
>
>I thought the maintainers were testing this driver over time :(

>thanks,
>
>greg k-h

Ick indeed. Maintainers are on it full time. Thank you very much for the flag. While I am only reporting activity, hope to have results soon.
Regards,
ganesh k 
