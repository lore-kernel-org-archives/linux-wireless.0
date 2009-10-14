Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:51002 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZJNANd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 20:13:33 -0400
Received: by ewy4 with SMTP id 4so3959644ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 17:12:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD4ED23.7010200@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
	 <1255382358-20760-4-git-send-email-hauke@hauke-m.de>
	 <3ace41890910121932r6f832fe8of70d9b2bdd3d2635@mail.gmail.com>
	 <4AD4ED23.7010200@hauke-m.de>
Date: Wed, 14 Oct 2009 01:12:56 +0100
Message-ID: <3ace41890910131712v700ebfe4vc1cd234f24abee9@mail.gmail.com>
Subject: Re: [PATCH 2/9] [compat-2.6 and compat-stable] Remove unused code
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 13, 2009 at 10:12 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:

> The condition #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)) was
> added recently because without it openSuse with kernel 2.6.27 will not
> compile. OpenSuse backports the tracepoint part into their 2.6.27 kernel.

I remember that thread now. It is probably wrong as a matter of policy
to incorporate patches for distro kernels with backport bits through.
- I am not saying you shouldn't be helpful and provide them - after
all, more users == better testing, and no doubt the investigation
itself throws more insights on the detailed mechanisms - but it is
just that compat-wireless probably should not try to support arbitrary
and substantial changes from a vanilla kernel. I know Suse is popular
so it is important to support Suse users, but I am wondering if
distro-specific changes should be separate or at least, clearly
documented.
