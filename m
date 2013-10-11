Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:48355 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab3JKUoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 16:44:22 -0400
Received: by mail-vb0-f43.google.com with SMTP id h11so3141064vbh.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 13:44:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131011153026.GA13099@localhost>
References: <20131011153026.GA13099@localhost>
Date: Fri, 11 Oct 2013 21:44:20 +0100
Message-ID: <CAFSJ42Z3fpBbr3j5X1q7T1iQ8a0KZtw0jHnAO+_DBaKuXtLZ9Q@mail.gmail.com> (sfid-20131011_224429_218022_295B6B3F)
Subject: Re: [wireless-next:master 82/98] drivers/net/wireless/ath/wcn36xx/smd.c:1330:2-8:
 preceding lock on line 1324
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good patch, thanx!

On Fri, Oct 11, 2013 at 4:30 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> Hi Eugene,
>
> FYI, there are coccinelle warnings in
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
> head:   e25aa82a89db9e3b09d02b5481aa375c7712a10d
> commit: 8e84c25821698bdef73c0329fb2022a4673b7adc [82/98] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
>
>>> drivers/net/wireless/ath/wcn36xx/smd.c:1330:2-8: preceding lock on line 1324
> --
>>> drivers/net/wireless/ath/wcn36xx/debug.c:27:11-31: WARNING opportunity for simple_open, see also structure on line 106
>>> drivers/net/wireless/ath/wcn36xx/debug.c:27:11-31: WARNING opportunity for simple_open, see also structure on line 148
>
> Please consider folding the attached diff :-)
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



-- 
Best regards,
Eugene
