Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbZAWWQm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:16:42 -0500
Subject: [PATCH 0/7 v2] airo: cleanups and simplifications
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 23 Jan 2009 17:15:14 -0500
Message-Id: <1232748914.447.2.camel@localhost.localdomain> (sfid-20090123_231647_256810_FBC442D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

airo needs some hot sexy love.  come and get your love come and get your
love now.

[PATCH 1/7 v2] airo: clean up and clarify interrupt-time task handling
[PATCH 2/7 v2] airo: re-arrange WPA capability checks
[PATCH 3/7 v2] airo: simplify WEP index and capability checks
[PATCH 4/7 v2] airo: clean up WEP key operations
[PATCH 5/7 v2] airo: use __attribute__ ((packed)) not #pragma
[PATCH 6/7 v2] airo: clean up and clarify micinit()
[PATCH 7/7 v2] airo: remove useless #defines

(v2 changes: rebased onto wireless-testing 2008-01-23)


