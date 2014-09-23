Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.jelmoni.net ([78.47.55.82]:49962 "EHLO mail.jelmoni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbaIWWwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 18:52:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.jelmoni.net (Postfix) with ESMTP id C367B6183A
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 00:44:38 +0200 (CEST)
Received: from mail.jelmoni.net ([78.47.55.82])
	by localhost (mail.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tUr9ci9BMC4B for <linux-wireless@vger.kernel.org>;
	Wed, 24 Sep 2014 00:44:38 +0200 (CEST)
Received: from laptop-bmeier.swiss-wireless (host41.186-108-120.telecom.net.ar [186.108.120.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: genauth@swiss-wireless.com.ar)
	by mail.jelmoni.net (Postfix) with ESMTPSA id D634C61742
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 00:44:37 +0200 (CEST)
Message-ID: <5421F7D0.8040105@swiss-wireless.com.ar> (sfid-20140924_005253_636975_61C2F310)
Date: Tue, 23 Sep 2014 19:44:32 -0300
From: Beat Meier <mbe_ml@swiss-wireless.com.ar>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org >> Linux Wireless List"
	<linux-wireless@vger.kernel.org>
Subject: iw dev X survey dump output very different for ath5k and ath9k cards
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I'm having "trouble" with output of iw (Debian Wheezy, Voyage-0.9.2)
iw version: 3.4-1
libiw30 version: 30~pre9-8

The output of iw dev X survey dump is very different for the
WLM54AGP23 card (ath5k) and WLM200NX (ath9k).
Is there any reason for ath9k to print the whole stuff?
Is there any other possibility to get frequency on ap mode?

Where is this handled?

Greetings

Beat


#########
Output of WLM WLM54AGP23

# iw dev ath1 survey dump
Survey data from ath1
        frequency:                      5825 MHz
        noise:                          -107 dBm
        channel active time:            375099 ms
        channel busy time:              292088 ms
        channel receive time:           285473 ms
        channel transmit time:          171443 ms

#########

Output of WLM200NX

# iw dev ath1 survey dump
Survey data from ath1
        frequency:                      2412 MHz
        noise:                          -95 dBm
        channel active time:            428 ms
        channel busy time:              25 ms
        channel receive time:           17 ms
        channel transmit time:          0 ms
Survey data from ath1
        frequency:                      2417 MHz
Survey data from ath1
        frequency:                      2422 MHz
Survey data from ath1
        frequency:                      2427 MHz
Survey data from ath1
        frequency:                      2432 MHz
Survey data from ath1
        frequency:                      2437 MHz
Survey data from ath1
        frequency:                      2442 MHz
Survey data from ath1
        frequency:                      2447 MHz
Survey data from ath1
        frequency:                      2452 MHz
Survey data from ath1
        frequency:                      2457 MHz
Survey data from ath1
        frequency:                      2462 MHz
Survey data from ath1
        frequency:                      2467 MHz
Survey data from ath1
        frequency:                      2472 MHz
Survey data from ath1
        frequency:                      2484 MHz
Survey data from ath1
        frequency:                      5180 MHz
Survey data from ath1
        frequency:                      5200 MHz [in use]
        noise:                          -95 dBm
        channel active time:            1302308 ms
        channel busy time:              1856 ms
        channel receive time:           2 ms
        channel transmit time:          1460 ms
Survey data from ath1
        frequency:                      5220 MHz
Survey data from ath1
        frequency:                      5240 MHz
Survey data from ath1
        frequency:                      5260 MHz
Survey data from ath1
        frequency:                      5280 MHz
Survey data from ath1
        frequency:                      5300 MHz
Survey data from ath1
        frequency:                      5320 MHz
Survey data from ath1
        frequency:                      5500 MHz
Survey data from ath1
        frequency:                      5520 MHz
Survey data from ath1
        frequency:                      5540 MHz
Survey data from ath1
        frequency:                      5560 MHz
Survey data from ath1
        frequency:                      5580 MHz
Survey data from ath1
        frequency:                      5600 MHz
Survey data from ath1
        frequency:                      5620 MHz
Survey data from ath1
        frequency:                      5640 MHz
Survey data from ath1
        frequency:                      5660 MHz
Survey data from ath1
        frequency:                      5680 MHz
Survey data from ath1
        frequency:                      5700 MHz
Survey data from ath1
        frequency:                      5745 MHz
Survey data from ath1
        frequency:                      5765 MHz
Survey data from ath1
        frequency:                      5785 MHz
Survey data from ath1
        frequency:                      5805 MHz
Survey data from ath1
        frequency:                      5825 MHz

