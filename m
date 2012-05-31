Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46484 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2EaDOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 23:14:53 -0400
Received: by pbbrp8 with SMTP id rp8so828356pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 20:14:53 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20422.57801.731014.743866@gargle.gargle.HOWL> (sfid-20120531_051457_786926_31B30245)
Date: Thu, 31 May 2012 08:43:13 +0530
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Sujith Manoharan <m.sujith@gmail.com>
Subject: convinced bug in RSSI reporting for AR9280/ath9k_htc/htc_7010.fw
In-Reply-To: <CA+7oygf50aro8VrHekWFJvSb3hhOsZUP9ybUeUE1WaYzx2MNHA@mail.gmail.com>
References: <CA+7oygf50aro8VrHekWFJvSb3hhOsZUP9ybUeUE1WaYzx2MNHA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

George Nychis wrote:
> This would explain why in my other thread that the RSSI values for
> beacons for my AP acted as expected and all other RSSI values did not
> follow as expected.
> 
> I would greatly appreciate it if someone could chime in here.  Sujith?

Thanks for reporting this, we'll do some tests to see what's wrong.

Sujith
