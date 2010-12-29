Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38468 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0L2Q4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 11:56:06 -0500
Received: by fxm20 with SMTP id 20so10600916fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 08:56:05 -0800 (PST)
Message-ID: <4D1B6821.5040506@lwfinger.net>
Date: Wed, 29 Dec 2010 10:56:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Weedy <weedy2887@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Compile error for the last week inside rtlwifi/base.c
References: <loom.20101228T075242-208@post.gmane.org> <4D1A0EF1.8060509@lwfinger.net> <loom.20101229T034155-409@post.gmane.org>
In-Reply-To: <loom.20101229T034155-409@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/28/2010 08:43 PM, Weedy wrote:
> Larry Finger <Larry.Finger@...> writes:
> 
>> Older kernels used create_workqueue(), which is replaced by alloc_workqueue()
>> If you really need the driver for RTL8192CE/RTL8188CE, then apply the patch
>> shown below. If you do not need the driver, then disable it in the 
>> configuration.
>>
>> Larry
> 
> Actually I need RTL8192USB, I guess I need to wait more?

What are the USB Ids as shown by the lsusb command?

Larry
