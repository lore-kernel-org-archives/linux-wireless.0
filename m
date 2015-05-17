Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:48306 "EHLO
	mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbbEQQSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 12:18:10 -0400
From: Stefan Bruens <stefan.bruens@rwth-aachen.de>
To: <linux-wireless@vger.kernel.org>
Subject: Support of TX timestamps in kernel / by hardware
Date: Sun, 17 May 2015 18:08:21 +0200
Message-ID: <5898815.03gqQSlLcY@pebbles.site> (sfid-20150517_181814_402622_0A86262C)
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have looked through the individual hardware drivers, but there seems to be 
no way of getting an accurate time when an individual packet preamble hits the 
antenna.

For RX, most drivers support a RX timestamp based on the TSF and put this into  
struct ieee80211_rx_status -> mactime. For TX, I found nothing related.

Kind regards,

Stefan

-- 
Stefan Brüns  /  Bergstraße 21  /  52062 Aachen
home: +49 241 53809034     mobile: +49 151 50412019

