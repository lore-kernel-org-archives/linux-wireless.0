Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:50291 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbZKSBmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 20:42:37 -0500
Received: by qw-out-2122.google.com with SMTP id 3so405141qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 17:42:43 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 17:42:43 -0800
Message-ID: <8999a3120911181742y364c763j3b5b88e50890332c@mail.gmail.com>
Subject: scanning question
From: Chuck Tuffli <ctuffli@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm implementing a mac80211 driver and have a question about the
expected behavior during software based scanning. Can the driver
assume that mac80211 won't start a scan until all previous TX
complete? If not, what is the expected behavior of the driver? Finish
current TX before starting the scan? Drop current TX? Something else?
TIA!

---chuck
