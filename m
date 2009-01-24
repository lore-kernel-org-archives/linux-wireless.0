Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f10.google.com ([209.85.219.10]:47815 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZAXPmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 10:42:18 -0500
Received: by ewy3 with SMTP id 3so159529ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 07:42:16 -0800 (PST)
Message-ID: <497B36D5.3080609@gmail.com> (sfid-20090124_164319_481840_EA5DD3C5)
Date: Sat, 24 Jan 2009 16:42:13 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Valentin <apo@apo2k4.ath.cx>
CC: linux-wireless@vger.kernel.org
Subject: Re: p54 + ISL3887 + master mode?
References: <20090124150103.612d8985@lucien>
In-Reply-To: <20090124150103.612d8985@lucien>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Valentin wrote:
> Hi, I recently got a Dell Wireless 1450 USB and am now trying to put it
> into master mode, but to no avail... I've tried this:
> 
> ./iw phy phy6 interface add dell type (master|ap)
> 
> but both just give me the help. Trying to add a device in e.g. monitor
> or managed mode works. If I then try
> 
> iwconfig dell mode master
> 
> I get
> 
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device dell ; Invalid argument.
> 
> Now I'm pretty much out of ideas. Is it actually possible to get this
> into master mode? :|
> 
> --Valentin
> 
> 
> PS: Same results with ubuntu hardy's 2.6.24-22-generic kernel and debian
> lenny's 2.6.26-1-486.

you probably want a kernel w/ at least this 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e5ea92a7528d304e8e327d0d261653e98b163e8a
hence 2.6.29+ or even newer to get the other p54 fixes.
no need to manually tweak the modes, just launching hostapd is enough.

artur
