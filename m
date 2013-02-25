Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:60577 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab3BYSSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 13:18:18 -0500
Message-ID: <11214452.15864921361816296422.JavaMail.defaultUser@defaultHost> (sfid-20130225_191824_960978_FB50A34D)
Date: Mon, 25 Feb 2013 19:18:16 +0100 (CET)
From: Fabio Rossi <rossi.f@inwind.it>
Reply-To: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: regression with kernel 3.8
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using the latest wireless-testing.git and I have found a regression with 
kernel 3.8. I don't know if this is related to the driver I'm using (ath5k) but 
I have bisected the problem to the commit 
6c17b77b67587b9f9e3070fb89fe98cef3187131 (mac80211: Fix tx queue handling 
during scans). Basically the authentication and association infos don't appear 
anymore in the kernel logs during a connection to my access point.

Tell me what you need to further debug the issue and solve the problem.

Fabio

