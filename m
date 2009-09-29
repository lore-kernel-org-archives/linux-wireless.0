Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:64776 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZI2HEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 03:04:12 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH] libertas: Add auto deep sleep support for SD8385/SD8686/SD8688
Date: Tue, 29 Sep 2009 09:04:00 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com> <1253458691.11702.46.camel@localhost.localdomain> <477F20668A386D41ADCC57781B1F704306DDA6C1B6@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704306DDA6C1B6@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909290904.00971.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing !

Please note that I just sent an experimental patch to enable 
cfg80211 for libertas.

Once this is polished, you can immediately start using 
nl80211/cfg80211 to configure such things, there's no need to 
have the full thingy (e.g. wpa_supplicant via -Dnl80211 working 
with WEP/WPA/WPA2) working, those things are not interrelated.


-- 
http://www.holgerschurig.de
