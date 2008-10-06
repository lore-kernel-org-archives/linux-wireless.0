Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:21142 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYJFN4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:56:32 -0400
Received: by an-out-0708.google.com with SMTP id d40so141561and.103
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 06:56:31 -0700 (PDT)
Message-ID: <eb3ff54b0810060656v1d97d286md06d37782ed14afd@mail.gmail.com> (sfid-20081006_155637_126710_A473FCA4)
Date: Mon, 6 Oct 2008 15:56:30 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 0/2] iwlwifi: fix compilation warning when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set fixes compliation warning when CONFIG_IWLWIFI_DEBUG is not set
and CONFIG_IWLWIFI is set
It is build against the wireless-next-2.6 tree.
