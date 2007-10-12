Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:16384 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXJLPAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 11:00:47 -0400
Received: by el-out-1112.google.com with SMTP id v27so226629ele
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 08:00:46 -0700 (PDT)
Date: Fri, 12 Oct 2007 11:00:52 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 0/5] ath5k: promiscuous bug, multicast, modes and docs
Message-ID: <20071012150052.GA9407@pogo> (sfid-20071012_160050_198642_41A9C427)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds a few things which have been sitting in my
queue. Nick has better fixes for two of my previous patches so
he'll be sending that. In this series I also added some new mode
fixes, and added Nick's new comments the hw interrupts docs.

I've taken the time to run checkpatch.pl now ;)

  Luis
