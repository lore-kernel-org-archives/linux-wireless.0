Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53445 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2DMQIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 12:08:01 -0400
Received: by ghrr11 with SMTP id r11so1713552ghr.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2012 09:08:00 -0700 (PDT)
Message-ID: <4F884F5C.5010101@lwfinger.net> (sfid-20120413_180812_261495_8B1EFC95)
Date: Fri, 13 Apr 2012 11:07:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jan Simonson <jan@simonson.se>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
References: <1502184.lhzNHmlX61@ymer> <3893847.nxaiIbI8jN@ymer> <4F85AB14.4000204@lwfinger.net> <3126669.vN7HHIeqdy@ymer>
In-Reply-To: <3126669.vN7HHIeqdy@ymer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/13/2012 10:11 AM, Jan Simonson wrote:
> onsdagen den 11 april 2012 11.02.28 skrev  Larry Finger:
>> I copied the kernel source into a separate directory and created a
>> stand-alone  build file. All that is working, but I discovered that
>> sometime since kernel 3.2, the driver stopped working with my AP that uses
>> WPA and 802.11g. The AP's that run 802.11g/WEP and 802.11n/WPA2 are OK. I'm
>> bisecting now to find that problem.
>
> Thanks, I'm standing by for information of where I can find your ftp site when
> you are finished working with the driver.

Bisection failed for some reason. I still have not found why 802.11g/WPA does 
not work.

Larry

