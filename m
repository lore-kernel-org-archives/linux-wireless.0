Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35431 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0L2Do1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 22:44:27 -0500
Received: by gxk9 with SMTP id 9so1401641gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 19:44:27 -0800 (PST)
Message-ID: <4D1AAE98.4080703@lwfinger.net>
Date: Tue, 28 Dec 2010 21:44:24 -0600
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

Yes. The rtlwifi driver is for PCIe devices.
