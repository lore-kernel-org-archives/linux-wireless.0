Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40160 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZHRDtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:49:42 -0400
Date: Tue, 18 Aug 2009 05:49:42 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/29] mwl8k update to version 0.10
Message-ID: <20090818034942.GE18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series, various mwl8k coding style cleanups, removal of the
usage of radio_enabled, some minor bug fixes, optimisations, and
removal of most of the driver's workqueue use.  (Against latest
wireless-testing.)
