Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:40038 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYETHG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 03:06:26 -0400
Received: by an-out-0708.google.com with SMTP id d40so527316and.103
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 00:06:23 -0700 (PDT)
Message-ID: <43e72e890805200006m56cf551yf3b3ab557c20b8ff@mail.gmail.com> (sfid-20080520_090631_475438_1970456C)
Date: Tue, 20 May 2008 00:06:23 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: iwlwifi Makefile issue in compat-wireless-2008-05-18
Cc: "John Goulah" <jgoulah@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1211255335.7814.5.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com>
	 <1211168475.31033.9.camel@debian.sh.intel.com>
	 <183c1cc10805190610h176cb8fcx54e6755fb5f36cfb@mail.gmail.com>
	 <1211245264.2532.24.camel@debian.sh.intel.com>
	 <183c1cc10805191823w5855227akce4aa1bb9f1b6198@mail.gmail.com>
	 <1211255335.7814.5.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2008 at 8:48 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Mon, 2008-05-19 at 21:23 -0400, John Goulah wrote:
>> Ok,  I assume you mean the patch for the kernel config that allows
>> this all to work?
>
> I mean the recent patch introduces CONFIG_IWLWIFI.
>
>> Would that mean you're not supporting compiling on any kernel older
>> than 2.6.26 with this change?
>
> I'd suggest we patch compat-wireless like this (given the fact it
> doesn't make use of Kconfig).
>
> Thanks,
> -yi
>
> --- config.mk   2008-05-20 11:46:55.000000000 +0800
> +++ /tmp/config.mk      2008-05-20 11:46:49.000000000 +0800
> @@ -30,6 +30,7 @@ ifneq ($(CONFIG_PCI),)
>
>  CONFIG_ATH5K=m
>  CONFIG_ATH5K_DEBUG=n
> +CONFIG_IWLWIFI=m
>  CONFIG_IWLCORE=m
>  CONFIG_IWL3945=m
>  CONFIG_IWL4965=m

Applied on compat-wireless.

thanks,

  Luis
