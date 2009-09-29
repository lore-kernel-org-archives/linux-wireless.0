Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:10596 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZI2HYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 03:24:16 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH] libertas: Add auto deep sleep support for SD8385/SD8686/SD8688
Date: Tue, 29 Sep 2009 09:24:07 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com> <1253458691.11702.46.camel@localhost.localdomain> <477F20668A386D41ADCC57781B1F704306DDA6C1B6@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704306DDA6C1B6@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909290924.07758.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> iwconfig wlan0 power period 0   -> enable deep sleep (enter
> deep sleep immediately) 

> iwconfig wlan0 power period 5   -> enable auto deep sleep
> (enter deep sleep automatically after 5s idle time) 

> iwconfig wlan0 power period -1  -> disable deep sleep / auto
> deep sleep 

ACK from my side (not that I'm the maintainer ...)

-- 
http://www.holgerschurig.de
