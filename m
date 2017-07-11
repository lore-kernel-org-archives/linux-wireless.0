Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33181 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdGKBdW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 21:33:22 -0400
Received: by mail-oi0-f66.google.com with SMTP id f134so13928138oig.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 18:33:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/2] rtlwifi: Fix two static errors
Date: Mon, 10 Jul 2017 20:33:11 -0500
Message-Id: <20170711013313.3478-1-Larry.Finger@lwfinger.net> (sfid-20170711_033337_939368_675658E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter reported two problems found in changes that were merged
into kernel 4.12. One of them involves twp variables that might not
be initialized. The second is a potential use after free error.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Ping-Ke Shih (2):
  rtlwifi: fix static checker warning of uninitialized symbol.
  rtlwifi: fix static checker warning of dereferencing freed memory

 drivers/net/wireless/realtek/rtlwifi/base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.12.3
