Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62109 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab0KLTQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:16:21 -0500
Received: by iwn10 with SMTP id 10so3808449iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 11:16:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDD91BA.6000003@openwrt.org>
References: <4CDD70FA.40402@openwrt.org> <4CDD91BA.6000003@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 12 Nov 2010 11:16:01 -0800
Message-ID: <AANLkTinqd0soSAeTe0CtsXdnRvFHfBXa-YipNV2LWVbm@mail.gmail.com>
Subject: Re: [PATCH v2] compat: fix pm_qos_params compile error on 2.6.35
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 11:12 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Linux 2.6.35 pm_qos_params.h is missing a #ifndef/define/endif around
> its header file contents, causing a compile error when its functions
> are overwritten by macros in the compat header files.
> Fix this by adding these to the compat version of this header file.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Applied and pushed, thanks!

 Luis
