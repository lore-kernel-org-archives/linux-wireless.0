Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab1BPMQj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 07:16:39 -0500
Date: Wed, 16 Feb 2011 13:16:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: compat-wireless-2011_02_15 missed rtlwifi/rtl8192c/dm_common.c
Message-ID: <20110216121616.GA2363@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Latest compat wireless fail to build, because rtlwifi/rtl8192c
directory is missed.

/builddir/build/BUILD/compat-wireless-next-2011_02_15/_kmod_build-compat-wireless-next-2.6.34.7-66.fc13.x86_64/drivers/net/wireless/rtlwifi/rtl8192ce/dm.o
/builddir/build/BUILD/compat-wireless-next-2011_02_15/_kmod_build-compat-wireless-next-2.6.34.7-66.fc13.x86_64/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c:38:35:
error: ../rtl8192c/dm_common.c: No such file or directory

Stanislaw
