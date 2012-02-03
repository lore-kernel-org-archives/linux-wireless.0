Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab2BCMHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:07:55 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/25] iwlegacy update 2012-02-03
Date: Fri,  3 Feb 2012 13:07:00 +0100
Message-Id: <1328270845-16891-1-git-send-email-sgruszka@redhat.com> (sfid-20120203_130800_006916_5FB30834)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set include various cleanups, mostly patches intended to
remove unused "ctx" structure.

