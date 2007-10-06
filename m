Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:17492 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615AbXJFBD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 21:03:26 -0400
Received: by wx-out-0506.google.com with SMTP id h31so630756wxd
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2007 18:03:25 -0700 (PDT)
Date: Fri, 5 Oct 2007 21:04:49 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 0/6] ath5k: initvals, radar, promiscuous bug and multicast
Message-ID: <20071006010449.GA25022@pogo> (sfid-20071006_020331_579801_F4CDD24C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds a few things which have been sitting in my
queue. The most important change is the proper fix for the promiscuous
bug.

        Luis
