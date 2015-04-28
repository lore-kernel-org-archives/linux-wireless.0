Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34855 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbbD1Jwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 05:52:55 -0400
Received: by labbd9 with SMTP id bd9so100098448lab.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2015 02:52:53 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 Apr 2015 11:52:53 +0200
Message-ID: <CAOFH_kHtkB6D=L1Ljx5j5vO4c20vW4omk7msz5c2K6W9gE4xhg@mail.gmail.com> (sfid-20150428_115259_166554_091E7356)
Subject: TX99 usage
From: Mathieu Slabbinck <matty.slabbinck@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we are having some troubles using TX99 for our wireless testing.
Our goal is to have a system that can modify:
- Tx gain
- data rate
- tx packet length
- tx mode (continuous/burst)
- specify tx antenna

Currently, we're using a 3.10 kernel with all patches needed to
provide tx99 functionality.
It seems to work fine to. Quick tests with different powers show
different occupation in the spectrum.

But changing for example the datarate seems to fail. It remains at 6.5M
command used: iw dev moni0 set bitrates legacy-5 24

Can anyone provide some pointers on how to change these things?
Is there a reference on how to use tx99 to accomplish all the above goals?

Kr

Mathieu
