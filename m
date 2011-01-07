Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48365 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1AGUlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 15:41:36 -0500
Received: by fxm20 with SMTP id 20so17293495fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 12:41:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinqd0soSAeTe0CtsXdnRvFHfBXa-YipNV2LWVbm@mail.gmail.com>
References: <4CDD70FA.40402@openwrt.org>
	<4CDD91BA.6000003@openwrt.org>
	<AANLkTinqd0soSAeTe0CtsXdnRvFHfBXa-YipNV2LWVbm@mail.gmail.com>
Date: Fri, 7 Jan 2011 15:41:35 -0500
Message-ID: <AANLkTik-+T=+LWriDP+nM32Nh0yQyLcyLgHOndtjWymE@mail.gmail.com>
Subject: Re: [PATCH v2] compat: fix pm_qos_params compile error on 2.6.35
From: Jason Andryuk <jandryuk@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 2:16 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Nov 12, 2010 at 11:12 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Linux 2.6.35 pm_qos_params.h is missing a #ifndef/define/endif around
>> its header file contents, causing a compile error when its functions
>> are overwritten by macros in the compat header files.
>> Fix this by adding these to the compat version of this header file.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>
> Applied and pushed, thanks!
>
>  Luis

This patch is to compile compat-wireless-2.6.37-2-sn.tar.bz2 on Ubuntu
10.10 2.6.35-24-generic.

Jason
