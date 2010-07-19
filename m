Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48662 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966632Ab0GSWTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 18:19:35 -0400
Received: from [192.168.1.103] (S0106001cf044e5ad.vc.shawcable.net [24.82.131.108])
	by mail.holtmann.org (Postfix) with ESMTP id ADFD98B4D8
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 00:19:32 +0200 (CEST)
Subject: iwlagn and many firmware restarts with Fedora kernel
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 11:43:54 -0700
Message-ID: <1279565034.4572.36.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

so during the last few weeks, I have seen a huge amount of firmware
restarts with my Intel 5350 card and Fedora 13 kernel (2.6.33.6-147).

iwlagn 0000:03:00.0: low ack count detected, restart firmware
iwlagn 0000:03:00.0: On demand firmware reload
iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19

If this happens then I don't see it once, I normally see this 10-20
times and the connectivity is stalled until the cards comes back to
life. I have seen patches that should have fixed this symptom, but they
might be also send to -stable since this is a major hassle.

The time without connectivity is something around 4-5 minutes or longer
when this happens. Not really funny.

Regards

Marcel


