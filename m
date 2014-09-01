Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37362 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaIAPiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 11:38:09 -0400
Received: by mail-pd0-f169.google.com with SMTP id g10so6482000pdj.28
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 08:38:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Sep 2014 17:38:07 +0200
Message-ID: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com> (sfid-20140901_173813_368381_480D49AD)
Subject: wmediumd performance penalty
From: Dani Camps <danicamps81@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am testing a simple 1-hop mesh network over wmediumd. The PHY rate I
have configured is 54 Mbps, and there is no loss, however the max
throughput I get is around 14 Mbps. Without wmediumd I get around 30
Mbps, which seems reasonable given the 54 PHY rate. As I noted above
there is no loss probability configured in wmediumd.

My impression is that the performance drop is due to the overhead of
switching between kernel and user space in wmediumd, however it
surprises me that the penalty is so high.

Has anyone had a similar experience? Could there be a way to overcome
this bottleneck?

Best Regards

Daniel
