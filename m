Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39978 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2GEJpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 05:45:34 -0400
Received: by gglu4 with SMTP id u4so7160472ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 02:45:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339874808-9991-1-git-send-email-notasas@gmail.com>
References: <1339874808-9991-1-git-send-email-notasas@gmail.com>
Date: Thu, 5 Jul 2012 12:45:33 +0300
Message-ID: <CANOLnOPfO4Jcfs24tRDu=80bmJNYvFigLi2oKyu3ZUtP4Rz1mQ@mail.gmail.com> (sfid-20120705_114538_957757_4AFD6AD9)
Subject: Re: [PATCH 0/3] wl1251: maemo fixes
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 16, 2012 at 10:26 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> Here are a few old wl1251 patches found in maemo repositories that haven't
> ever reached mainline. I did not keep 'From:' and s-o-b as the patches are
> rebased and slightly modified, also most emails are probably dead due to
> Nokia's reorganization, so original authors are just listed in commit
> messages.

Anything wrong with these? There was a comment on 0001, but that was a
question unrelated to the patch itself.

>
> Grazvydas Ignotas (3):
>   wl1251: remove unused filter_work
>   wl1251: fix filtering support
>   wl1251: send filters to firmware as they are set

I've just noticed this shortlog is wrong, but patches themselves that
were sent to the list are correct, do I need to resend? Here is the
right shortlog:

Grazvydas Ignotas (3):
  wl1251: fix TSF calculation
  wl1251: always report beacon loss to the stack
  wl1251: Fix memory leaks in SPI initialization

 drivers/net/wireless/ti/wl1251/acx.c   |    2 +-
 drivers/net/wireless/ti/wl1251/event.c |    3 +--
 drivers/net/wireless/ti/wl1251/spi.c   |    4 ++++
 3 files changed, 6 insertions(+), 3 deletions(-)
