Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:46406 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032055AbeCAP2A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 10:28:00 -0500
Received: by mail-qt0-f181.google.com with SMTP id m13so7962293qtg.13
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 07:28:00 -0800 (PST)
MIME-Version: 1.0
From: Phani Siriki <yvsg.phanis@gmail.com>
Date: Thu, 1 Mar 2018 09:27:59 -0600
Message-ID: <CADsGw2ZBPK1hBY-a+v_1mVUOaFP3Uu5A4euyTc-070E4vSUrBg@mail.gmail.com> (sfid-20180301_162825_230390_93235854)
Subject: Query on queues in mesh mode
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All

I am trying to understand the queuing mechanism wireless mesh networks.

As per AP mode is concerned, there are four queues (BK, BE, Vi, VO)
and traffic is controlled based on CWmin, CWmax, AIFS and TxOP.

Does, mesh mode also involve these queues? Does mesh mode have any
queue or it is just a single queue?

Could someone clarify this?

Best Regards
Phani
