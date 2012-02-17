Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64687 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2BQX7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 18:59:45 -0500
Received: by iacb35 with SMTP id b35so5044756iac.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 15:59:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329472141-28781-2-git-send-email-coelho@ti.com>
References: <1329472141-28781-1-git-send-email-coelho@ti.com> <1329472141-28781-2-git-send-email-coelho@ti.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Feb 2012 15:59:25 -0800
Message-ID: <CAB=NE6Vd1FtdiwvR8H4TCRvt+=fQDVkT+oSeCziCWTVR6Eo0sg@mail.gmail.com> (sfid-20120218_005948_652671_024D55C2)
Subject: Re: [PATCH 2/2] compat-wireless: update makefiles patch for latest wireless-testing
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 17, 2012 at 1:49 AM, Luciano Coelho <coelho@ti.com> wrote:
> The drivers/net/usb/Makefile doesn't have qmi_wwan.o anymore, so we
> don't need to patch it out with the latest wireless-testing.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>

It seems this one hasn't made it to linux-next.git yet so I'll wait on
applying until it does. Just FYI, compat-wireless uses linux-next.git,
so there may be one or two day delays between subsystem integration
changes.

  Luis
