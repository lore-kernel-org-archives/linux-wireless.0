Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33759 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab2DKQCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 12:02:32 -0400
Received: by iagz16 with SMTP id z16so1438496iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 09:02:32 -0700 (PDT)
Message-ID: <4F85AB14.4000204@lwfinger.net> (sfid-20120411_180235_878806_AE91C8DF)
Date: Wed, 11 Apr 2012 11:02:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jan Simonson <jan@simonson.se>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
References: <1502184.lhzNHmlX61@ymer> <20120409192630.GB26994@tuxdriver.com> <4F835FB9.5020100@lwfinger.net> <3893847.nxaiIbI8jN@ymer>
In-Reply-To: <3893847.nxaiIbI8jN@ymer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 10:51 AM, Jan Simonson wrote:
>
> That would be very helpful! I look forward to hear from you again when it's
> available on your ftp site.
>
> Thanks again for helping me with this problem.

I copied the kernel source into a separate directory and created a stand-alone 
build file. All that is working, but I discovered that sometime since kernel 
3.2, the driver stopped working with my AP that uses WPA and 802.11g. The AP's 
that run 802.11g/WEP and 802.11n/WPA2 are OK. I'm bisecting now to find that 
problem.

Larry

