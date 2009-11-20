Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:59926 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZKTBhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 20:37:22 -0500
Received: by iwn8 with SMTP id 8so2234185iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2009 17:37:28 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 19 Nov 2009 17:37:08 -0800
Message-ID: <43e72e890911191737i5b82ca27xe0c363e02a05f497@mail.gmail.com>
Subject: There will not be a 2.6.32-rc8 compat-wireless package
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because the 2.6.32-rc8 diff stat includes no wireless fixes:

Fast forward
 Makefile                |    2 +-
 drivers/char/vt_ioctl.c |    6 +++---
 drivers/pci/dmar.c      |    3 +++
 fs/nfs/nfs4proc.c       |    2 +-
 include/linux/vt.h      |    4 ++--
 net/sunrpc/addr.c       |   18 ++++++++----------

  Luis
