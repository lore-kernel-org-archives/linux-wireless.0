Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43173 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbcI1Ns7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 09:48:59 -0400
Received: from potku.adurom.net (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CDB4F61818
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 13:48:57 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: wireless-drivers-next closed for 4.9
Date: Wed, 28 Sep 2016 16:48:54 +0300
Message-ID: <87bmz8w2wp.fsf@kamboji.qca.qualcomm.com> (sfid-20160928_154913_854718_08724B9B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just pushed the last patches to wireless-drivers-next and I'm planning
to send the final pull request to Dave tomorrow. This means that
wireless-drivers-next is closed and will open again for patches going to
4.10 sometime after 4.9-rc1 is released. Feel free to submit patches at
this time, they will be just queued in patchwork until the tree is open
again.

For Linux release schedules estimations PHB crystal ball is a nice
service. The deadline for wireless-drivers patches is usually a week
before the merge window opens.

http://phb-crystal-ball.org/

wireless-drivers remains open for important bug and regressions fixes to
4.9.

-- 
Kalle Valo
