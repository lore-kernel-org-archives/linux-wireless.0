Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:54991 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbcHWH1g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 03:27:36 -0400
Subject: Re: checkpatch: See if modified files are marked obsolete in
 MAINTAINERS
To: Joe Perches <joe@perches.com>
References: <87shtwvm63.fsf@kamboji.qca.qualcomm.com>
 <7ceaa510dc9d2df05ec4b456baed7bb1415550b3.1471889575.git.joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andy Whitcroft <apw@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <d5365370-37b5-b367-ba9e-45f4e27f975a@users.sourceforge.net> (sfid-20160823_092822_915044_7FD1CB98)
Date: Tue, 23 Aug 2016 09:26:51 +0200
MIME-Version: 1.0
In-Reply-To: <7ceaa510dc9d2df05ec4b456baed7bb1415550b3.1471889575.git.joe@perches.com>
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Use get_maintainer to check the status of individual files.
> If "obsolete", suggest leaving the files alone.

Will another software system like the "kbuild test robot"
need any more fine-tuning for this change?

Regards,
Markus
