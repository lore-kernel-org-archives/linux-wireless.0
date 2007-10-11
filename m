Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:50140 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbXJKTja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 15:39:30 -0400
Received: by wx-out-0506.google.com with SMTP id h31so681751wxd
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 12:39:25 -0700 (PDT)
Date: Thu, 11 Oct 2007 15:39:18 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] ath5k: promiscuous bug, multicast and some docs
Message-ID: <20071011193918.GB4334@pogo> (sfid-20071011_203936_183635_E654AF9E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds a few things which have been sitting in my
queue. Nick has better fixes for two of my previous patches so
he'll be sending that. In this series I also added some new docs
for some hw interrupts.

  Luis
