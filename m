Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:50536 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaBRUWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 15:22:44 -0500
Received: by mail-we0-f177.google.com with SMTP id t61so12135091wes.36
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 12:22:43 -0800 (PST)
Message-ID: <5303C107.9060309@gmail.com> (sfid-20140218_212247_983234_4C2A5820)
Date: Tue, 18 Feb 2014 20:22:31 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: vt6656: Remove variable fKillEventPollingThread
References: <1392672273.11154.13.camel@canaries64-MCP7A> <20140218190046.GA20757@kroah.com>
In-Reply-To: <20140218190046.GA20757@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/02/14 19:00, Greg KH wrote:
> On Mon, Feb 17, 2014 at 09:24:33PM +0000, Malcolm Priestley wrote:
>> We already kill the urb and since patch
>> s_nsInterruptUsbIoCompleteRead add urb status returns.
>> have error handling
>>
>> There is no need for this variable.
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
>>
>> Conflicts:
>> 	drivers/staging/vt6656/usbpipe.c
>
> Why is this in your Changelog entry?
>
Oh sorry, I should have deleted it.

It was cherry picked from another git branch where patch 1
didn't exist and was fixed.



