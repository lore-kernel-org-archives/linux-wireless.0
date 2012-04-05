Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.polito.it ([130.192.182.65]:15029 "EHLO mx.polito.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab2DENkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 09:40:13 -0400
Received: from polito.it (eracle.polito.it [130.192.3.44])
	by fm1nodo5.polito.it  with ESMTP id q35DeAEk013148-q35DeAEl013148
	for <linux-wireless@vger.kernel.org>; Thu, 5 Apr 2012 15:40:10 +0200
Received: from [130.192.86.1] (HELO [192.168.85.111])
  by eracle.polito.it (CommuniGate Pro SMTP 5.4.3)
  with ESMTPS id 55774335 for linux-wireless@vger.kernel.org; Thu, 05 Apr 2012 15:40:10 +0200
Message-ID: <1333633209.24092.12.camel@MacGyver> (sfid-20120405_154018_737215_61310C8B)
Subject: ath9k coalescence parameters
From: Guido Gavilanes <gavilanes@ismb.it>
Reply-To: gavilanes@ismb.it
To: linux-wireless@vger.kernel.org
Date: Thu, 05 Apr 2012 15:40:09 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello guys,
I have seen that for ethtool, it is possible to change rx-usecs or
rx-frames of the NIC to control the interrupt frequency.

I intend to minimize the idle times between the packet rx and packet
processing by the cpu, so I am trying 2 alternatives:

1) Find a way to set up the interrupt frequency by setting the number of
packets (or time passed) before the netcard generates the interrupt; is
this possible?

2) Disabling power saving (since I see it has consequences on interrupt
handling), but it seems it is not supported in AP mode. Is there a way
to achieve this?

I have been googling for the topic without success...

Thank you!!

Guido




