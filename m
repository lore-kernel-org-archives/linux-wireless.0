Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:57509 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958Ab2CAM2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 07:28:16 -0500
Message-ID: <4F4F6B5A.6060202@mlbassoc.com> (sfid-20120301_132820_468634_2732F6C9)
Date: Thu, 01 Mar 2012 05:28:10 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <coelho@ti.com>
Subject: Re: Problems with wl1271
References: <4F4E903B.2030501@mlbassoc.com> <CAK=WgbbO2fv-hp6vJ8-rhRvzGgs26kd5UGWp_vWveXb_VmpsoA@mail.gmail.com>
In-Reply-To: <CAK=WgbbO2fv-hp6vJ8-rhRvzGgs26kd5UGWp_vWveXb_VmpsoA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-01 05:13, Ohad Ben-Cohen wrote:
> On Wed, Feb 29, 2012 at 10:53 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> If I try to scan for an access point, I get nothing:
>>   # iw wlan0 scan
>>   --- Nothing prints
>
> You might be using a wrong reference clock value (see
> include/linux/wl12xx.h for more info, look for 'clock').

Yes, that was it :-)  I added the "board_ref_clock" to my
platform parameters and now I'm getting something from the
scan.

Thanks for the help

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
