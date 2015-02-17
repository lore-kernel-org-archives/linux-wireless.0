Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbbBQP67 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 10:58:59 -0500
Message-ID: <1424188728.31336.0.camel@dcbw.local> (sfid-20150217_165903_042727_AD742C69)
Subject: Re: Can not download Intel 4965AGN Linux driver
From: Dan Williams <dcbw@redhat.com>
To: =?UTF-8?Q?=E8=82=96=E6=96=8C?= <xiaobin@fio.org.cn>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Date: Tue, 17 Feb 2015 09:58:48 -0600
In-Reply-To: <1c8b04a6.1399.14b97ff5cbe.Coremail.xiaobin@fio.org.cn>
References: <1c8b04a6.1399.14b97ff5cbe.Coremail.xiaobin@fio.org.cn>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-17 at 22:44 +0800, 肖斌 wrote:
> Hello,
> My laptop's wireless chip-set is Intel 4965AGN, and my OS is Ubuntu12.04, 
> recently the wifi connection drops evey few minutes, so I'm trying to 
> re-install the wifi driver, but the Linux driver seems not available on 
> the internet:
> https://wireless.wiki.kernel.org/en/users/drivers/iwlegacy
> Where can I get the Linux wifi driver?

The driver is built with your kernel, so there is no need to download it
from anywhere.  When the kernel is updated you will get a new version of
the driver.  If there are bugs in the driver, you should report them to
your distro, and if they solve them, they will update the kernel and you
will get the bug fixes.

Dan

