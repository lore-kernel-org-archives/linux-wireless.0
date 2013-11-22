Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40718 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab3KVPca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 10:32:30 -0500
Message-ID: <528F7900.7050602@hauke-m.de> (sfid-20131122_163233_969536_258F0D1B)
Date: Fri, 22 Nov 2013 16:32:16 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?6JKL5rOi?= <skylvlinux@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: look for the dirver support ath6kl (in the kernel version >3.0)
References: <CAKH5=Lv8J1kAkX9tKyZRR7mZ7r3c85sB8fZ8TOXqeHmeEU4CTQ@mail.gmail.com>
In-Reply-To: <CAKH5=Lv8J1kAkX9tKyZRR7mZ7r3c85sB8fZ8TOXqeHmeEU4CTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2013 07:20 AM, 蒋波 wrote:
> hello all
>  i find the compat-wireless-3.3.rc-2.tar.gz
>  i try transplant  ath6kl into the kernel 3.3
> but it occur lots of interface error  (can't gain the *.ko )
> so , you have good solution for it
> thanks advance!

The version number in compat-wireless, compat-drivers and backports does
not says which kernel version this is for, but it says where the code is
from, there is no reason to use compat-wireless-3.3.rc-2.tar.gz with
kernel 3.3, you probably got even older wireless code.

You should use one of these releases, they should work with your kernel 3.3:
http://drvbp1.linux-foundation.org/~mcgrof/rel-html/backports/

Hauke
