Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47134 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab1DGU14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 16:27:56 -0400
Received: by fxm17 with SMTP id 17so1931585fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 13:27:55 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	anarsoul@gmail.com
Subject: [PATCH RFC 0/3] libertas: powersave fixes
Date: Thu,  7 Apr 2011 23:25:57 +0300
Message-Id: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series attempts to make libertas driver a bit powersave friendlier by
adding .set_power callback, so common part can disable hw when it's necessary
(when iface is down or before going into suspend). Also it adds implementation of
.set_power callback for if_spi subdriver.

