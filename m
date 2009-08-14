Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:65114 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbZHNWMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 18:12:52 -0400
Received: by wf-out-1314.google.com with SMTP id 26so504579wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 15:12:53 -0700 (PDT)
Message-ID: <4A85E160.9080906@lwfinger.net>
Date: Fri, 14 Aug 2009 17:12:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>
Subject: Re: [PATCH] b43: LP-PHY: Fix another TX power control abuse
References: <4A85D070.6070702@gmail.com> <4A85D7A3.9020009@lwfinger.net> <69e28c910908141500s2e6ee71avcebffd6107fe5a1@mail.gmail.com>
In-Reply-To: <69e28c910908141500s2e6ee71avcebffd6107fe5a1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 2009/8/14 Larry Finger <Larry.Finger@lwfinger.net>:
>> Yes, this one got rid of the warnings.
>>
>> Larry
>>
>>
> 
> I guess the device still doesn't TX/RX.
> 

Not yet. The fact that it keeps getting shut down/restarted indicates
that the TX operations are not completing. I'm currently tracking the
path of operations.

Larry
