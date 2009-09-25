Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:10034 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZIYG7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 02:59:10 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Balaji Ravindran <b@w1an.in>
Subject: Re: Question on general wireless testing tree compilation.
Date: Fri, 25 Sep 2009 08:58:58 +0200
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
References: <16D9C5FD-4A2A-4061-9C26-FF5C0B0CDFBA@w1an.in>
In-Reply-To: <16D9C5FD-4A2A-4061-9C26-FF5C0B0CDFBA@w1an.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909250858.58989.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I followed the instructions from
> http://www.cyberciti.biz/tips/compiling-linux-kernel-26.html 
> and ended up with a compile error in 'make', while trying to
> create the bzimage. (error is on make: initramfs_data.cpi.o
> failed) 

Hmm, I simply compile almost-self-contained kernels, without any 
initramfs. Slows down the boot and isn't needed for the usual 
IDE/SATA desktop PCs anyway.

If you don't want to go that way, you'd better post the whole 
error. Maybe when doing "make V=1", and include some (10 or so) 
lines from above the error message above.

-- 
http://www.holgerschurig.de
