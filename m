Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53589 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1FNSir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 14:38:47 -0400
Received: by iwn34 with SMTP id 34so4884958iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 11:38:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 14 Jun 2011 11:38:25 -0700
Message-ID: <BANLkTi=bd9KgU7Fc_LYchR9jDKQx=gKv6Q@mail.gmail.com> (sfid-20110614_203850_644656_D5A5F095)
Subject: Re: [PATCH v2 00/11] compat-wireless: Add support for kernel 3.XX
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 9, 2011 at 3:03 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This patch series mostly add support for kernel 3.XX.
> Some of these patches are needing patches for compat.git.
>
> The patches with "Add to compat-3.0-stable" should also be applied to
> linux-3.0.0.y.
>
> The generation of CONFIG_COMPAT_KERNEL_2_6_XX and
> CONFIG_COMPAT_KERNEL_3_XX is not clean, this has to be improved later,
> but it works for now.
>
> v2:
>  * integrate comments from Jonas
>  * add bcma
>  * fix some more patches and add missing bluetooth header
>  * rename CONFIG_COMPAT_KERNEL_26XX to CONFIG_COMPAT_KERNEL_2_6_XX

Awesome, thanks so much. I've applied all these and the compat.git
patches, and also propagated to a stable branch for both compat.git
and compat-wireless.git the patches you identified as such.

  Luis
