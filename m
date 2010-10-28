Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57019 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933Ab0J1Qnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 12:43:41 -0400
Received: by iwn10 with SMTP id 10so2554623iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 09:43:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <728838.98715.qm@web56803.mail.re3.yahoo.com>
References: <728838.98715.qm@web56803.mail.re3.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Oct 2010 09:43:07 -0700
Message-ID: <AANLkTikShmy=8DU113jmfDtmsPyZwgB1Cv9VM2orWVCR@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: fix update-initramfs script
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 28, 2010 at 2:14 AM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> There are traces of a widespread error logs from installing
> compat-wireless pertaining to update-initramfs, as google would
> suggest. Ubuntu 10.10, for example complains of excessive:
> "FATAL: Could not load /lib/modules/2.6.31-wl/modules.dep: No such file or directory"
> Other distributions/kernels: "Cannot find /lib/modules/2.6.31-wl"
>
> * Fix kernel version detection
> * Fix updating of initramfs. Instead of generating new initramfs image,
> simply update the existing one. This makes update-grub redundant, which
> is good thing, considering it messes with people's grub.cfg settings
> every time compat-wireless is installed. At some point replacing this
> script in Makefile with "@update-initramfs -u" will probably be best.
>
>
> Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>

applied both and pushed, thanks!

  Luis
