Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63153 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZKUSxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 13:53:37 -0500
Received: by yxe17 with SMTP id 17so3734587yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 21 Nov 2009 10:53:43 -0800 (PST)
Subject: Re: Kernel compilation Question
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Balaji Ravindran <b@w1an.in>
In-Reply-To: <200911211910.40687.s.L-H@gmx.de>
Date: Sat, 21 Nov 2009 10:46:28 -0800
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Message-Id: <B6B420E5-2AFB-46D7-B200-B081ACC4F783@w1an.in>
References: <4B080EFA.6000300@w1an.in> <200911211910.40687.s.L-H@gmx.de>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephen,

Thanks for your reply. Wow, the four references that you provided makes lot more sense to me. I shall try using some examples in readme mentioned below.

Thanks

Balaji R
On Nov 21, 2009, at 10:10 AM, Stefan Lippers-Hollmann wrote:

> Hi
> 
> On Saturday 21 November 2009, Balaji Ravindran wrote:
>> Hi all,
>> 
>> I tried compiling the wireless 2.6 kernel on my debian machine using
>> make-kpkg and being lazy, i just did make defconfig, and saw that my
>> compilation went fine without any issues, but i noticed that there was
>> no ramdisk image that was generated when i installed the linux-image*.deb.
> 
> For questions about Debian specific packaging helpers like 
> kernel-package[1], you would better contact debian-user@lists.debian.org 
> instead.
> 
>> i did use --initrd option,
> [...]
> 
> Please read /usr/share/doc/kernel-package/README.gz [2], it explains which 
> hook scripts you have to configure for generating an initramfs, --initrd is
> not sufficient anymore[3] (since kernel-package 12.000).
> 
> Also consider that the Debian kernel team considers kernel-package to be 
> deprecated in favour of the upstream kernel build system's own 
> "make deb-pkg" target[4]. 
> 
> Unrelated to this topic, I'd suggest to take the configs of your running 
> (distribution-) kernel as starting point, because this likely introduces 
> the least amount of surprise (ide vs. libata storage layer, etc.).
> 
> Regards
> 	Stefan Lippers-Hollmann
> 
> [1]	http://packages.debian.org/sid/kernel-package
> [2]	http://git.debian.org/?p=users/srivasta/debian/kernel-package.git;a=blob;f=README (line 284ff)
> [3]	http://www.golden-gryphon.com/blog/manoj//blog/2009/04/07/Not_your_father__39__s_kernel-package/
> [4]	http://lists.debian.org/debian-kernel/2009/10/msg00613.html

