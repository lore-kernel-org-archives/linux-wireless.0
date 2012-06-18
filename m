Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46897 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab2FRK6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 06:58:04 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 0/5] bind filters and multicast list to subif
Date: Mon, 18 Jun 2012 12:57:10 +0200
Message-ID: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120618_125810_280350_ACD04A35)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Following patches enables configuring filters and multicast list for
specific interface. That probably might be useful in implementation
of multi-channel operation.

BR,
Lukasz

