Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:55213 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYEWQNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 12:13:39 -0400
Received: by fg-out-1718.google.com with SMTP id 19so433779fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 09:13:37 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/4] rt2x00: minor update
Date: Fri, 23 May 2008 18:13:30 +0200
MIME-Version: 1.0
Message-Id: <200805231813.30511.IvDoorn@gmail.com> (sfid-20080523_181343_463472_499D21F0)
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are 4 patches intended for 2.6.26,
it fixes a memleak, fix pessimistic link quality calculation,
antenna diversity bug and a scheduling while atomic bug.

Ivo
