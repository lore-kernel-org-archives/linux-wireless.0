Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from co300216-co-outbound.net.avaya.com ([198.152.13.100]:5407 "EHLO
        co300216-co-outbound.net.avaya.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752496AbcKQSMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 13:12:44 -0500
From: "Vuille, Martin (Martin)" <vmartin@avaya.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question about regional "adaptivity" / CCA settings
Date: Thu, 17 Nov 2016 18:08:13 +0000
Message-ID: <30C2D590D16A5C46ADFE6521910377987FF82389@AZ-US1EXMB02.global.avaya.com> (sfid-20161117_191249_051953_32F800F4)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ETSI EN-300-328 and EN-301-893 set requirements for "adaptivity"
behaviour of Wi-Fi controllers.

Other regions may have different requirements.

If I understand correctly, regional requirements related to DFS are
managed through the Linux wireless infrastructure and the wireless-regdb.

Is there anything similar for "adaptivity"?

MV
