Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33222 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161164AbdDUMpc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 08:45:32 -0400
Received: by mail-io0-f178.google.com with SMTP id k87so118299886ioi.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Apr 2017 05:45:32 -0700 (PDT)
MIME-Version: 1.0
From: Belisko Marek <marek.belisko@gmail.com>
Date: Fri, 21 Apr 2017 14:44:48 +0200
Message-ID: <CAAfyv35fScotYnQdGadrCBCU7pShG3zGqzkyRR2Utfh-KG8-UQ@mail.gmail.com> (sfid-20170421_144554_604525_8E2EEECB)
Subject: ad-hoc mode max speed on 8812au wifi card
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Corin Moss <corin.moss@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm doing small research on mesh with batman-adv module by using
8812au wifi adapters. I can setup 2 nodes mesh network in 2.4 or 5GHz
bands but max speed (tested with iperf) is only ~2.5MBytes. I read
something about limitation of ad-hoc that speed is restricted to
11Mbits even if it's connected in 5GHz channels. I can assume that
this limitation is due some wifi aliance restriction or is there other
reason (like avoid too many transmissions)? Would be possible to
increase ad-hoc mode speed somehow when using 8812au wifi card. Thanks
a lot for replies and hints.

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
