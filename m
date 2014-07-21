Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([206.191.95.214]:27777 "EHLO
	mail.lenbrook.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaGUM6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 08:58:45 -0400
Message-ID: <53CD0B33.5070208@lenbrook.com> (sfid-20140721_145848_860834_C8434BD6)
Date: Mon, 21 Jul 2014 08:44:35 -0400
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: kihun.hong@secui.com, linux-wireless@vger.kernel.org
Subject: Re: compile backport-3.15.1-1 with Kernel 2.6.35.14
References: <14532028.366481405919563475.JavaMail.weblogic@epml01>
In-Reply-To: <14532028.366481405919563475.JavaMail.weblogic@epml01>
Content-Type: text/plain; charset=EUC-KR
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-07-21 01:12 AM, È«±âÈÆ wrote:
> Hi all, 
>
> I am trying to compile backport-3.15.1-1 with Kernel 2.6.35.14 for the AP mode of the ath9k driver.
> (I only did "make menuconfig" and add  KLIB= "compiled and installed kernel path" in a Makefile.)
>
> In Kernel 2.6.35.14, however, I got many errors "error: linux/printk.h: No such file or directory". 
> Because many file loactation (Directory) were changed between 2.X and 3.X kernel versions.
I started getting the "error: linux/printk.h: No such file or directory"
at backports 3.14-1. backports 3.13.2-1 works with 2.6.35.3

-- 
Jonathan Bagg
Embedded Systems Developer
NAD Electronics | Lenbrook Industries Limited
633 Granite Court, Pickering, Ontario, Canada L1W 3K1 | 905-831-0799 ext 4478 | http://www.nadelectronics.com

