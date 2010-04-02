Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38465 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0DBEp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 00:45:26 -0400
Received: by pwi5 with SMTP id 5so1558456pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 21:45:26 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 1 Apr 2010 21:45:06 -0700
Message-ID: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
Subject: iwlagn unexpected AddBA Req
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[  117.491303] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
[  178.467383] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
[  239.447236] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0

I get a lof of these at spurious times against my WRT610N using
today's wireless-testing on iwlagn.

  Luis
