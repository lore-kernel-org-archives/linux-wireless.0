Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:19414 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYEAIY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 04:24:59 -0400
Received: by ug-out-1314.google.com with SMTP id z38so1656466ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2008 01:24:58 -0700 (PDT)
To: linville@tuxdriver.com
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Thu, 1 May 2008 10:29:15 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211906.45496.IvDoorn@gmail.com>
In-Reply-To: <200804211906.45496.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805011029.15850.IvDoorn@gmail.com> (sfid-20080501_102459_439810_28A56067)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> Finally a new official rt2x00 release,
> off course I have send a lot of patches over the past few weeks
> with several bugfixes, but now I am bumping the versions to 2.1.5.
> 
> Please consider this patch series for the 2.6.26 kernel,

Was this patch series in time for the 2.6.26 merge window?

If not, please consider merging at least the following patches since
they are real bugfixes:

>       rt2x00: Don't enable short preamble for 1MBs
>       rt2x00: Fix quality/activity led handling
>       rt2x00: Clarify supported chipsets in Kconfig

The others are code cleanups which are "nice to have", but could otherwise
wait for 2.6.27.

>       rt2x00: Support hardware RTS and CTS-to-self frames
>       rt2x00: Remove DRIVER_SUPPORT_MIXED_INTERFACES
>       rt2x00: Use rt2x00 queue numbering
>       rt2x00: Add helper macros
>       rt2x00: Fix kernel-doc
>       rt2x00: Release rt2x00 2.1.5

Thanks,

Ivo
