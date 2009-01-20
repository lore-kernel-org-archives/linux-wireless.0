Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZATOqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 09:46:07 -0500
Subject: [PATCH 0/7] airo: cleanups and simplifications
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 20 Jan 2009 09:44:51 -0500
Message-Id: <1232462691.22158.6.camel@localhost.localdomain> (sfid-20090120_154614_323101_DADED421)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

airo needs some hot sexy love.  come and get your love come and get your
love now.

[PATCH 1/7] airo: clean up and clarify interrupt-time task handling
[PATCH 2/7] airo: re-arrange WPA capability checks
[PATCH 3/7] airo: simplify WEP index and capability checks
[PATCH 4/7] airo: clean up WEP key operations
[PATCH 5/7] airo: use __attribute__ ((packed)) not #pragma
[PATCH 6/7] airo: clean up and clarify micinit()
[PATCH 7/7] airo: remove useless #defines



