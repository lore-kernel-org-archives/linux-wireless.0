Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vsmtp1.tin.it ([212.216.176.141]:38392 "EHLO vsmtp1.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaBELgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 06:36:43 -0500
Received: from [192.168.1.103] (62.211.204.225) by vsmtp1.tin.it (8.6.060.28) (authenticated as a_siracusano@tin.it)
        id 52E62DC700ADE285 for linux-wireless@vger.kernel.org; Wed, 5 Feb 2014 12:30:50 +0100
Message-ID: <1391599819.4118.3.camel@Core2> (sfid-20140205_123648_303891_D67D3994)
Subject: Reduce tx power
From: Giuseppe Siracusano <a_siracusano@tin.it>
To: linux-wireless@vger.kernel.org
Date: Wed, 05 Feb 2014 12:30:19 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi to all

Is it possible to set the trasmission power to a value  lower than 1 mW
(0 dBm) ? If the answer is no, why.  Is there a  phyisical limit in the
chip or is just a driver limit?

I'm trying to simulate a large wireless mesh network using machines that
are close toghether, so now every machine has the complete "visibility"
of the network. My goal is to limit the visibility to only a subset of
nodes. I can not move the machines, and the drivers that I'm using are
ath5k.

Bye

Giuseppe Siracusano


