Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nyet.org ([66.175.217.148]:53258 "EHLO ln.curtisfong.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754240AbeDBJvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Apr 2018 05:51:40 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by ln.curtisfong.org (Postfix) with ESMTP id C9532D4D7
        for <linux-wireless@vger.kernel.org>; Mon,  2 Apr 2018 02:44:17 -0700 (PDT)
Received: from ln.curtisfong.org ([127.0.0.1])
        by localhost (ln.curtisfong.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IedoMOdbLcjK for <linux-wireless@vger.kernel.org>;
        Mon,  2 Apr 2018 02:44:17 -0700 (PDT)
Received: from [192.168.19.169] (rrcs-76-80-9-214.west.biz.rr.com [76.80.9.214])
        by ln.curtisfong.org (Postfix) with ESMTPSA id 9A96FD4D3
        for <linux-wireless@vger.kernel.org>; Mon,  2 Apr 2018 02:44:17 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Nye Liu <nyet@nyet.org>
Subject: iwlwifi: completely opaque WARN_ON(1) at
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1363. Please remove or fix it
 (TX_STATUS_FAIL_DEST_PS)
Message-ID: <423cffeb-fabc-78fc-c2f6-7d9e226fc051@nyet.org> (sfid-20180402_115144_333260_A89D3364)
Date: Mon, 2 Apr 2018 02:44:17 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX_STATUS_FAIL_DEST_PS

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=887045
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1733194

Please remove or fix the WARN_ON(1) at 
drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1363 it is filling my kernel 
logs
