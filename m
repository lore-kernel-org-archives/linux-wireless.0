Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:46847 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900AbZGGQ2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 12:28:49 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1521103fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 09:28:47 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Jul 2009 00:28:47 +0800
Message-ID: <5135d20a0907070928o19322c3waf41a7b59d4b309e@mail.gmail.com>
Subject: a question about marvell sd8686's wmm_config_change event
From: fengzeheng <zehengfeng@gmail.com>
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, dan and all
     My wireless card sd8686 reports that wmm_config_change about
every 2 seconds though wmm's setting in AP's beacons don't change.
seems that driver receive MACREG_INT_CODE_WMM_STATUS_CHANGE event from
firmware every 2 seconds. And according
to firmware spec v5.1  this event generated when firmware monitors a
change in wmm state. This is a result of an ap change in the wmm
parameter ie or a change in the operational state of one of the AC
queues. However ,  I can't find any change of AP's wme settings in
beacon from the sniffer packets. So why does firmware send this event?
thanks for your any comments.

-- 
Best Regards
Fzh
