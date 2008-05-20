Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbYETTdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 15:33:22 -0400
Subject: mrv8k: now gets scan results
From: Dan Williams <dcbw@redhat.com>
To: Markus Becker <mab@comnets.uni-bremen.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 20 May 2008 15:33:33 -0400
Message-Id: <1211312013.10737.10.camel@localhost.localdomain> (sfid-20080520_213326_441619_2870D0B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've gotten mrv8k to the point where I can get scan results with it on
my 3COM 3CRGPC10075 CardBus card.  Data RX still doesn't work for some
reason and WEP associations still fail with a mac80211 timeout.  Enough
for today though.  All changes pushed to mrv8k.git on infradead.

Dan


