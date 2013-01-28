Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58761 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A1Jdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:33:53 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so3544810lbb.40
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2013 01:33:52 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: ath9k has buggy promiscuous mode
Date: Mon, 28 Jan 2013 10:33:48 +0100
Message-ID: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be> (sfid-20130128_103357_206380_7DC3BDE1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

When using promiscuous mode on a ath9k chipset, it does not capture 
packets from the access point to other stations.

e.g. a ping from S to T over AP results in:
echo request S -> AP
echo reply AP -> S

Where echo request AP -> T is missing.

System:
Linux openWRT 3.3.8
driver: ath9k

Best regards,
Erwin

