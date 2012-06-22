Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38163 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2FVRAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:00:30 -0400
Received: by obbuo13 with SMTP id uo13so2182797obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 10:00:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340371854-24101-1-git-send-email-ozancag@gmail.com>
References: <1340371854-24101-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 22 Jun 2012 10:00:05 -0700
Message-ID: <CAB=NE6XAMQmU3pU+hD3+RZMCj4kiKS50phtLdmYtYhM7mxy+-w@mail.gmail.com> (sfid-20120622_190033_365356_D065B7B1)
Subject: Re: [PATCH] compat-wireless: Naturally sort patch prefixes
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 6:30 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Use ls -v to get a naturally sorted list of patches like:
>
> patches/00-vga_switcheroo_client_ops.patch
> patches/01-dma_buf_ops-addition.patch
> patches/02-revert-vm_mmap.patch
> patches/98-pr_fmt.patch
> patches/99-change-makefile.patch
> patches/9999-FIXME-dont-build-i915-for-i2c-problems.patch
>
> instead of:
>
> patches/00-vga_switcheroo_client_ops.patch
> patches/01-dma_buf_ops-addition.patch
> patches/02-revert-vm_mmap.patch
> patches/98-pr_fmt.patch
> patches/9999-FIXME-dont-build-i915-for-i2c-problems.patch
> patches/99-change-makefile.patch
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Groovy, thanks applied and pushed!

  Luis
