Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61119 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1FQKUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 06:20:31 -0400
Received: by bwz15 with SMTP id 15so652847bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 03:20:30 -0700 (PDT)
Subject: Re: Status of carl9170
From: Thomas Novin <thomas@xyz.pp.se>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201106162249.14480.chunkeey@googlemail.com>
References: <1308255196.4264.7.camel@thnov-desktop.xyz.lan>
	 <201106162249.14480.chunkeey@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 17 Jun 2011 12:20:23 +0200
Message-ID: <1308306023.7789.9.camel@thnov-desktop.xyz.lan> (sfid-20110617_122035_798539_EF8EC779)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On tor, 2011-06-16 at 22:49 +0200, Christian Lamparter wrote:
> But at least, you could try to disable the 11n cap by loading the module
> with noht=1 and the hwcrypt by nohwcrypt=1.
> 
> Btw, do you have anything in your dmesg from the driver?

Serious difference! Transferring files both tx/rx with scp at full speed
while doing ping results in decent transfer speeds and no packet loss.

>From dmesg: http://paste.ubuntu.com/628344/

Thanks,

Thomas



