Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64160 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaFYKRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 06:17:35 -0400
Received: by mail-pb0-f41.google.com with SMTP id ma3so1536093pbc.0
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 03:17:35 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id pr8sm4495715pbc.74.2014.06.25.03.17.33
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 25 Jun 2014 03:17:34 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] Fixes for errors/warnings reported by code analyzers.
Date: Wed, 25 Jun 2014 15:47:26 +0530
Message-Id: <1403691446-4933-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140625_121738_920378_E8CD6982)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set contains fixes for warnings and errors reported by
static code analyzers.

Jahnavi Meher (2):
  rsi: Fixed errors and warnings reported by static code analyzers.
  rsi: Fixed warnings reported by static code analyzers.

 drivers/net/wireless/rsi/rsi_91x_core.c |   12 +++++++-----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    5 +++--
 2 files changed, 10 insertions(+), 7 deletions(-)

