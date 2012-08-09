Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51235 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2HIEqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 00:46:17 -0400
Received: by obbuo13 with SMTP id uo13so71681obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 21:46:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344487215-24143-1-git-send-email-andy@greyhouse.net>
References: <1344487215-24143-1-git-send-email-andy@greyhouse.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 8 Aug 2012 21:45:56 -0700
Message-ID: <CAB=NE6URAD4Wj0EVBP770pcEkJ8vezWW+kV5kuDG3KrdKdU8Ow@mail.gmail.com> (sfid-20120809_064620_845334_AD7C526F)
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
To: Andy Gospodarek <andy@greyhouse.net>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Phil Perry <phil@elrepo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 8, 2012 at 9:40 PM, Andy Gospodarek <andy@greyhouse.net> wrote:
> This patch allows me to compile and load the latest compat modules on
> RHEL6.3.  Users of compat on RHEL6 should note that you should set
> CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.
>
> These changes seem to pass built-in tests on my system:
>
> # ./bin/ckmake

No need to run as root, in fact I encourage both
bin/get-compat-kernels and bin/ckmake to be run as a regular user.

Thanks! Applied and pushed!

  Luis
