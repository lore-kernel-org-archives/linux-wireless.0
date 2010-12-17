Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12635 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab0LQDXZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:23:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 19:23:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 0/8] wireless: DFS region support
Date: Thu, 16 Dec 2010 19:23:09 -0800
Message-ID: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a list of changes to kernel and userspace
to start addressing DFS region support. I've cheated and
figured out a way to alter the current regulatory database
in such a way that it remains backwards compatible with
older databases so that no new CRDAs are required and we
don't have to provide two releases for old kernels and
newer kernels for wireless-regdb updates.

Let me know if this seems agreeable. In the end we end
up passing the DFS region to the drivers, the next question
then is what to do next.

  Luis
