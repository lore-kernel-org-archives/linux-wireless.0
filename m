Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63975 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2BAHKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 02:10:47 -0500
Received: by iacb35 with SMTP id b35so1099579iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 23:10:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327600856-29635-1-git-send-email-linville@tuxdriver.com>
References: <1327600856-29635-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 31 Jan 2012 23:10:26 -0800
Message-ID: <CAB=NE6UOxOio_yp4chFkcUQ_g2RkOouddViRajZjERvHSkhjUw@mail.gmail.com> (sfid-20120201_081051_276397_743B42F7)
Subject: Re: [PATCH] compat: use kconfig.h in compat-2.6.h for 3.1 and later kernels
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 10:00 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> This file was introduced in commit 2a11c8ea20bf850b3a2c60db8c2e7497d28aba99
> and included in 3.1 and later kernels.  It includes <generated/autoconf.h>
> itself, as well as some other definitions that are used elsewhere.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Apologies for the delay, and thanks a lot, applied and pushed!

  Luis
