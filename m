Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:43900 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbAKRAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 12:00:17 -0500
Received: by mail-ob0-f173.google.com with SMTP id uy5so19447419obc.4
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 09:00:16 -0800 (PST)
Message-ID: <54B2AC1B.8030107@lwfinger.net> (sfid-20150111_180022_910241_A3178D97)
Date: Sun, 11 Jan 2015 11:00:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= <francoisvalenduc@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Kernel crash while copying big files since kernel 3.18
References: <54AA3953.20603@gmail.com> <54AAC925.6050602@lwfinger.net> <54AADC22.9050105@gmail.com> <54AAE532.6050104@lwfinger.net> <54B28A3F.3000904@gmail.com>
In-Reply-To: <54B28A3F.3000904@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2015 08:35 AM, François Valenduc wrote:
> Do you still intend to remove the line about allocation failure in the
> log ? I made a backup of my root partition compressed with pixz and that
> line appeared 1350 times. So I removed the code which add this line. Is
> it really expected that it occurs so often ? pixz use multithreading to
> compress files and therefore at least 3 of the 4 CPU are used during
> around 20 minutes, but are you sure there is no other problems ?

Yes, I do intend to remove that line; however, I want to keep it for a while 
just in case there are other crashes. If this message never appears in that 
case, then there is another bug.

You are, of course, free to remove it from your system. BTW, how much memory do 
you have?

Larry


