Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46888 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2AaQiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 11:38:17 -0500
Received: by vcge1 with SMTP id e1so178716vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 08:38:16 -0800 (PST)
Message-ID: <4F2818F5.6000802@lwfinger.net> (sfid-20120131_173823_354839_B2036FD9)
Date: Tue, 31 Jan 2012 10:38:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: tim.gardner@canonical.com
CC: Tim Gardner <rtg.canonical@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] rtlwifi: Convert to asynchronous firmware load
References: <4f272b8e.6jAMcI3HDthxlb+q%Larry.Finger@lwfinger.net> <4F280689.1080402@canonical.com>
In-Reply-To: <4F280689.1080402@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2012 09:19 AM, Tim Gardner wrote:
>
>
> d88e0b3162bded8190866d9a17f5e36c9bb0d29e in wireless-testing (which includes
> 'rtlwifi: Convert to asynchronous firmware load') is working well on my
> RTL8188CE [10ec:8176].

Thanks for the feedback. Note: The patch was merged before V3 was available, 
thus you will also need the "rtlwifi: Remove extra debugging message 
accidentally left in" patch that I just sent to John.

Larry

