Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53030 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbeH1QLY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:11:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Peng Xu <pxu@qti.qualcomm.com>
Subject: [RFC 0/6] multi-BSSID patches
Date: Tue, 28 Aug 2018 14:13:47 +0200
Message-Id: <20180828121353.11193-1-johannes@sipsolutions.net> (sfid-20180828_142002_780794_F3A420C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm sending this out mostly as another hand-off/publishing, we don't
really think the patches are ready to be used in this form.

However, we did find a few issues in the original code, and the patches
address some of them.

If I remember correctly, we continued to have some list corruption
issues, and I'm also not sure hidden SSID merging was handled correctly
in the end.

johannes
