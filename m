Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33516 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdH3RDI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 13:03:08 -0400
Received: by mail-oi0-f48.google.com with SMTP id r203so56130841oih.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 10:03:08 -0700 (PDT)
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: RT2870 failure in kernel 4.12.8
Message-ID: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net> (sfid-20170830_190312_433048_1CDD4B29)
Date: Wed, 30 Aug 2017 12:03:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw and Helmut,

In a bug report at https://bugzilla.suse.com/show_bug.cgi?id=1055826, the OP 
reports that his RT3572 fails to work after an upgrade from the openSUSE 
Tumbleweed kernel 4.12.7 to 4.12.8. I checked the kernel configuration and did 
not see any problems.

Are you aware of anyone reporting problems with rt2800usb in 4.12.8 kernels?

Thanks,

Larry
