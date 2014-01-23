Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:51564 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaAWPuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:50:32 -0500
Received: by mail-oa0-f44.google.com with SMTP id g12so2323324oah.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 07:50:31 -0800 (PST)
Message-ID: <52E13A46.6050005@lwfinger.net> (sfid-20140123_165036_602386_04985AB4)
Date: Thu, 23 Jan 2014 09:50:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Obed_Gonz=E1lez?= <obedlink@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Wireless not working for rtl8192ce (RTL8188CE)/asus pce-n15
References: <1422360.xT36SRXFTZ@kubuntu>
In-Reply-To: <1422360.xT36SRXFTZ@kubuntu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2014 07:51 AM, Obed González wrote:
> [1]Wireless not working for rtl8192ce (RTL8188CE)/asus pce-n15
>
> [2] with kernel version equal or less than 3.12, the network manager asks for
> wireless password countless times.
>
> kernel with version 3.13 and later, the network administrator establishes
> connection with the router, gets an IP address, but no internet access, no
> access to the router, does not "ping" to any address. the network manager
> shows a bandwidth 1Mbits / s instead of the typical 54Mbits / s
>
> the connection using my wireless card only works with kernel version Ubuntu
> 12.04 LTS.

There are a lot of changes in this driver in the wireless-testing tree that will 
not be in the mainline tree until 3.14. Please generate a kernel from that repo.

Larry


