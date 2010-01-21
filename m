Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41768 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab0AUMFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 07:05:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Ath5k on 2.6.32 suddenly fails
Date: Thu, 21 Jan 2010 13:05:28 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <201001101152.34316.mb@bu3sch.de> <43e72e891001151447u39ad494ah6861926db0c50907@mail.gmail.com> <201001152350.06930.mb@bu3sch.de>
In-Reply-To: <201001152350.06930.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001211305.28456.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So so AP failed again.

This time with an older failure that I already reported in the past.

[92588.864887] ath5k phy0: unsupported jumbo
[92860.064977] ath5k phy0: unsupported jumbo
[93019.724035] ath5k phy0: unsupported jumbo
[93444.334305] ath5k phy0: unsupported jumbo
[161109.006052] ath5k phy0: unsupported jumbo
[186430.369739] ath5k phy0: unsupported jumbo
[210174.502973] ath5k phy0: no further txbuf available, dropping packet
[210175.527224] ath5k phy0: no further txbuf available, dropping packet
[210176.551473] ath5k phy0: no further txbuf available, dropping packet
...

Note that the "unsupported jumbo" messages seem to be harmless.
It fails, if these "dropping packet" messages appear.

Here's a wireshark log of the WM while I was trying to connect to
the AP with a device:
http://bu3sch.de/misc/quimbyfail
So it still beacons, but otherwise is completely dead.

-- 
Greetings, Michael.
