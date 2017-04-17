Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36072 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbdDQKHp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2017 06:07:45 -0400
From: Vincent Legoll <vincent.legoll@gmail.com>
To: linux-kernel@vger.kernel.org, zajec5@gmail.com,
        linux-wireless@vger.kernel.org
Subject: [PATCH RFC] Make BCMA a menuconfig to ease disabling it all
Date: Mon, 17 Apr 2017 12:07:29 +0200
Message-Id: <20170417100730.3648-1-vincent.legoll@gmail.com> (sfid-20170417_120818_028782_7B59EF9B)
In-Reply-To: <CAEwRq=oz=8T489QZtjcHB03rv_mFY6WAyOUkgMTOrsJuDEPPdw@mail.gmail.com>
References: <CAEwRq=oz=8T489QZtjcHB03rv_mFY6WAyOUkgMTOrsJuDEPPdw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

this is more what I wanted to achieve, an easily disableable BCMA menuconfig.

This is working as intended on x86_64 defconfig, whereas it is harder to disable
for ARCH=arm because of "select"s. But that's less of an issue, as those arch's
defconfigs may very well want the feature enbled, and that would make sense.

Any input appreciated.

Thanks
