Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56806 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaGUICK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 04:02:10 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so5975726wgh.6
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 01:02:08 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: bzhao@marvell.com, daniel@zonque.org,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 0/1] mwifiex: card reset: enable rescan of non-removable card
Date: Mon, 21 Jul 2014 10:01:51 +0200
Message-Id: <1405929712-27268-1-git-send-email-afenkart@gmail.com> (sfid-20140721_100218_001259_599A9E43)
In-Reply-To: <CALtMJEAwvMrZcFW7+ACgDNRVi+O5LE0p8gRUTUN3pNh8N1Eiog@mail.gmail.com>
References: <CALtMJEAwvMrZcFW7+ACgDNRVi+O5LE0p8gRUTUN3pNh8N1Eiog@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v2
- replaced global variable by local 'target' variable

Andreas Fenkart (1):
  mwifiex: card reset: enable rescan of non-removable card

 drivers/net/wireless/mwifiex/sdio.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.0.1

