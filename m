Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45427 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1HBXrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 19:47:01 -0400
Message-ID: <4E388C71.5080808@lwfinger.net> (sfid-20110803_014719_454009_38C3C877)
Date: Tue, 02 Aug 2011 18:46:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8192cu: add USB ID for Belkin n300 Micro USB wireless
 adapter
References: <201108022229.58532.s.L-H@gmx.de> <4E386FB9.2040507@lwfinger.net> <201108030035.50214.s.L-H@gmx.de> <201108030120.21059.s.L-H@gmx.de>
In-Reply-To: <201108030120.21059.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2011 06:20 PM, Stefan Lippers-Hollmann wrote:
>
> So at least the reported Oops is not specific to 050d:2103, but happens
> for any USB ID injected at runtime through sysfs and therefore appears
> to be a general issue with rtl8192cu.

As your system and mine are both x86_64, I had hoped to use your dump to find 
the offending statement. Unfortunately, the codes don't exactly match. I'll 
duplicate your experiment here and send you a trial patch.

Thanks for the report.

Larry
