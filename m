Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab0FQW6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 18:58:44 -0400
Message-ID: <4C1AA6BC.8000702@redhat.com>
Date: Thu, 17 Jun 2010 18:50:36 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: wireless-next-2.6 compile broken
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, as I mentioned in my previous email, the wireless-next-2.6 kernel
tree is not compiling.

This is because the wireless-next-2.6 tree is missing linux-2.6 commit
6c1f716e8154ee9315534782b9b1eedea0559a24,  but has wireless-next-2.6
commit 832c10fd733893f86c63bde1c65b005d5a2fe346 ... which explicitly
depends on the linux-2.6 commit.

FYI,

P.
