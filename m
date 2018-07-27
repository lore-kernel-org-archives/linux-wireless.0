Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49732 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730318AbeG0O5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:57:31 -0400
Received: from [192.168.1.47] (unknown [50.34.195.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 809F040A539
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2018 06:35:30 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: ath9k and 16 VAP interfaces?
Message-ID: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com> (sfid-20180727_153536_391734_7CC20D2E)
Date: Fri, 27 Jul 2018 06:35:28 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Has anyone tried making ath9k able to support 16 vAP interfaces on a single
radio?  I seem to recall that there were limitations regarding beacon
timers and such, and that is why the current limit is 8?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
