Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33289 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3EGMA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 08:00:59 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: Q: how to control aggregation parameters
Date: Tue, 7 May 2013 15:00:53 +0300
Message-ID: <4435058.lvXA3rBapG@lx-vladimir> (sfid-20130507_140104_003103_48B12470)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do we have some way to control aggregation from user space:

- enable/disable A-MSDU aggregation
- enable/disable A-MPDU aggregation (per RAxTID,
  set agg_wsize and other ADDBA params)
- parameters for A-MPDU on recipient side (accept/reject,
  max agg_wsize, etc.)

I mean, who defines policy for ADDBA flows?
