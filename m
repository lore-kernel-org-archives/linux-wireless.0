Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbcBAWDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 17:03:13 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jakub Sitnicki <jsitnicki@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: rtl8xxxu updates - inital rtl8723bu/rtl8192eu support
Date: Mon, 01 Feb 2016 17:03:12 -0500
Message-ID: <wrfj4mds3x7j.fsf@redhat.com> (sfid-20160201_230316_563829_FDF1B712)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For anyone interested in the rtl8xxxu driver, then I just pushed code
which can handle rtl8723bu and rtl8192eu into the repository. In
particular the rtl8192eu support is still very experimental.

It's all in the rtl8xxxu-nextgen branch for now.

Cheers,
Jes
