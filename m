Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:40774 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3KYWMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 17:12:16 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so5079359oag.2
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 14:12:16 -0800 (PST)
Message-ID: <5293CB3E.6090104@lwfinger.net> (sfid-20131125_231220_325569_7289A7B0)
Date: Mon, 25 Nov 2013 16:12:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>, p2p@posteo.de
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8188S
References: <a3a1cb41444ae8dd89db830ae927491f@posteo.de> <2035998.63y5xTAJxx@blech>
In-Reply-To: <2035998.63y5xTAJxx@blech>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2013 03:57 PM, Christian Lamparter wrote:
>> I thought RTL8192cu will work, but Larry F. told me it doesn't.
> OK? (care to explain?)

The driver for an RTL81{88,92}CU device (rtl8192cu) will not work for the 
RTL81{88,92}SU device. There are substantial differences between the CU and SU 
chips.

Larry


