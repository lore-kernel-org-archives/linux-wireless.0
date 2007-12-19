Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:38966 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753883AbXLSAHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:07:37 -0500
Date: Wed, 19 Dec 2007 01:02:31 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/8] rate control rework
Message-ID: <20071219010231.6173926e@morte> (sfid-20071219_000740_288524_525ADC44)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is the result of my recent joint-venture with Mattias. It
introduces a new rate control algorithm based on a PID controller. First
tests show it works much better than the old simple rate control
algorithm.

I think that this should really go into 2.6.25, as the current rate control
algorithm was just written for reference and performs very poorly.

Johannes' and John's concerns have been addressed here.

Patches 1 to 3 introduce the PID controller algorithm. Patches 4 and 5 are
algorithm enhancements, while 6 to 8 are meant for debugging and tuning.


--
Ciao
Stefano
