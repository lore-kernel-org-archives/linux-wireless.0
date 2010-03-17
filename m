Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:18156 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0CQIx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 04:53:29 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCHv2 0/2] mac80211: cfg80211: Roam trigger support
Date: Wed, 17 Mar 2010 09:54:35 +0100
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless@vger.kernel.org
References: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com> <1268776349.8918.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1268776349.8918.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003170954.35547.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm curious. How does the HW/firmware do this?

Libertas firmware supports this, for example. There's a  
CMD_802_11_SUBSCRIBE_EVENT where I can ask the firmware to send me an event if 
one or more of the following things happen:

SNR_HIGH   averaged SNR (db) above threshold
RSSI_HIGH  averaged RSSI (dBm) above threshold
LINK_LOSS  consecutive no of beacons missed
MAX_FAIL   consecutive tx retries above threshold
SNR_LOW    averaged SNR below threshold
RSSI_LOW   averaged RSSI below threshold

-- 
http://www.holgerschurig.de
