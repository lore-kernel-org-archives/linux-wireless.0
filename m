Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34553 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763164Ab3DDGSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 02:18:11 -0400
Received: by mail-pd0-f179.google.com with SMTP id x11so1257453pdj.10
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2013 23:18:10 -0700 (PDT)
From: Matteo <matteo.danieletto@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: [ath6kl] Datalink Parameters
Date: Wed, 3 Apr 2013 23:18:08 -0700
Message-Id: <C6DACF60-6F6A-452C-AC26-B35BB166924F@gmail.com> (sfid-20130404_081814_966963_38D6FFE2)
Cc: ath6kl-devel@qualcomm.com
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I am looking for some data link parameters like: rx packets, tx packets, rx fragments, tx fragment, rx duplicate, tx retry and the range CWmin-CWmax, Rssi.
I found something in /sys/kernel/debug/ieee80211/*/ath6kl reading the file tgt_stats but there are field like: rx byte and rx packet ever equal zero.
Do you know why?

Furthermore, can you explain which information are in fwlog and how I can read it?

Thanks a lot
Matteo
 


