Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep23.mx.upcmail.net ([62.179.121.43]:53958 "EHLO
	fep23.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3GPSXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 14:23:37 -0400
Message-ID: <51E58FA5.4000804@odi.ch> (sfid-20130716_202354_753912_0A8E92B0)
Date: Tue, 16 Jul 2013 20:23:33 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
References: <51E4501D.3010001@odi.ch> <20130716065626.GA1587@redhat.com> <51E4F790.6090308@odi.ch> <51E51712.4020609@broadcom.com>
In-Reply-To: <51E51712.4020609@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without NetworkManager, no X, on console and with plain jane wpa_supplicant I do
echo mem > /sys/power state

After that, it still responds to keyboard events: I can switch VT and type on 
the consoles, but I can not login on a different VT (pressing Enter after the 
username doesn't return). So I guess tasks have been frozen, but it hangs in 
stopping devices.

settings for pm_test:
devices: same behviour as above
freezer: works as expected (stops tasks; sleeps; resumes tasks)

Nothing in the logs. How can I enable more log?

Ortwin
