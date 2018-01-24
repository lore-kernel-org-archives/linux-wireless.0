Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:43357 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964999AbeAXTIm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 14:08:42 -0500
Received: by mail-qt0-f170.google.com with SMTP id s3so13089482qtb.10
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jan 2018 11:08:41 -0800 (PST)
MIME-Version: 1.0
From: Neelansh Mittal <neelansh@gmail.com>
Date: Thu, 25 Jan 2018 00:38:00 +0530
Message-ID: <CANg=XDQ0g1=BzJnbbKYyH=Jyx7hTRRem2YL5hqEM0tiB-buwLA@mail.gmail.com> (sfid-20180124_200846_028108_F8C231E6)
Subject: Regulatory: reg.c : wiphy_apply_custom_regulatory()
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Can wiphy_apply_custom_regulatory() be called after wiphy registeration?
The documentation(comment) says "/* Used by drivers prior to wiphy
registration */"
Whys is there a restriction to call this after registration? Is the
comment outdated? After Tracing the regulatory code in the cfg80211,
it seems that there should be no restriction.

Regards
Neelansh
