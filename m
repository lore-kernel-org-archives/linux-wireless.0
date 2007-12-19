Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:60215 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754591AbXLSAcW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:32:22 -0500
Date: Wed, 19 Dec 2007 01:25:09 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v3 0/8] rate control rework
Message-ID: <20071219012509.721c834e@morte> (sfid-20071219_003224_042024_A61A8A21)
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
This patchset won't (hopefully!) get line-wrapped.

Patches 1 to 3 introduce the PID controller algorithm. Patches 4 and 5 are
algorithm enhancements, while 6 to 8 are meant for debugging and tuning.


--
Ciao
Stefano
