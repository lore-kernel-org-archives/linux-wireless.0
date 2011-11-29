Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45721 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1K2TRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 14:17:21 -0500
Received: by ywa9 with SMTP id 9so4438834ywa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 11:17:20 -0800 (PST)
Message-ID: <4ED52FBD.5030302@lwfinger.net> (sfid-20111129_201724_467372_AD65801D)
Date: Tue, 29 Nov 2011 13:17:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: AndrewL733 <AndrewL733@aol.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
References: <4ED3A6E8.4050000@aol.com> <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com> <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com> <4ED3B33E.8020309@lwfinger.net> <4ED3FA65.7010104@aol.com> <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com> <4ED51DB5.5090202@aol.com>
In-Reply-To: <4ED51DB5.5090202@aol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2011 12:00 PM, AndrewL733 wrote:
> Thanks for your reply.
>
> You are absolutely right. My Mandriva kernel's name is 3.1.2-1.1-desktop but the
> compat-wireless "make install" is installing everything in the directory
> /lib/modules/3.1.2-1-desktop/updates. The path is missing the ".1" before the
> "-desktop".
>
> I'm not sure why this is happening. I am running a Mandriva kernel from "Cooker"
> (running Mandriva 2011, which comes with 2.6.38.x, but the Macbook Pro 8,2 DVD
> isn't recognized until the 3.1 kernel. I also compiled my own 3.2-rc3 kernel but
> then I can't get fglrx to work properly.
>
> The joys of Macs and Linux..
>
> But getting back to b43. How can I instruct "make install" to put the drivers in
> the correct path? I'm going to try to just copy everything to the correct place
> and run depmod and see what happens. Maybe that'll work??

That path is derived from the current kernel version. It should get it right.

You should already have the directory /lib/modules/3.1.2-1.1-desktop. The 
command 'mv /lib/modules/3.1.2-1-desktop/updates to 
/lib/modules/3.1.2-1.1-desktop/.' followed by 'depmod -a' should be OK.

Larry

