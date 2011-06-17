Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42804 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1FQKva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 06:51:30 -0400
Received: by fxm17 with SMTP id 17so1665780fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 03:51:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Novin <thomas@xyz.pp.se>
Subject: Re: Status of carl9170
Date: Fri, 17 Jun 2011 12:52:19 +0200
Cc: linux-wireless@vger.kernel.org
References: <1308255196.4264.7.camel@thnov-desktop.xyz.lan> <201106162249.14480.chunkeey@googlemail.com> <1308306023.7789.9.camel@thnov-desktop.xyz.lan>
In-Reply-To: <1308306023.7789.9.camel@thnov-desktop.xyz.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201106171252.19937.chunkeey@googlemail.com> (sfid-20110617_125135_216466_CF2B053D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 June 2011 12:20:23 Thomas Novin wrote:
> On tor, 2011-06-16 at 22:49 +0200, Christian Lamparter wrote:
> > But at least, you could try to disable the 11n cap by loading the module
> > with noht=1 and the hwcrypt by nohwcrypt=1.
> > 
> > Btw, do you have anything in your dmesg from the driver?
> 
> Serious difference! Transferring files both tx/rx with scp at full speed
> while doing ping results in decent transfer speeds and no packet loss.
> 
> From dmesg: http://paste.ubuntu.com/628344/
Ok, can you please tell which option helped? If it was noht, then
you should check if there is a newer firmware for your router.

Regards,
	Chr
