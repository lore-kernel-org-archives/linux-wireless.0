Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57000 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1KQTav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 14:30:51 -0500
Received: by fagn18 with SMTP id n18so3378443fag.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 11:30:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321544559-2305-1-git-send-email-linville@tuxdriver.com>
References: <1321544559-2305-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Thu, 17 Nov 2011 11:30:29 -0800
Message-ID: <CAB=NE6X4+YHpDWtvo1bgqG25da4TrvS9EbUWVP5XnUSGn0Gq-w@mail.gmail.com> (sfid-20111117_203100_389373_294F387F)
Subject: Re: [PATCH] compat: support RHEL6 as a build target
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2011 at 7:42 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> This patch enables compatibility with RHEL6 as a build target, mostly
> with simple tricks similar to what was added for compatibility with
> Debian Squeeze.
>
> A handful of new CONFIG_* requirements were added, to provide for build
> flexibility required to support RHEL6:
>
>        CONFIG_COMPAT_KFIFO
>        CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP
>
> Also, CONFIG_COMPAT_FIRMWARE_CLASS is now checked in a header file and
> so the build configuration must change to update compat_autoconf.h
> appropriately
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Same for this guy.

  Luis
