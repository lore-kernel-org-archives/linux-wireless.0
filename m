Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47231 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106AbYF0TvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 15:51:12 -0400
Message-ID: <486544FA.20605@lwfinger.net> (sfid-20080627_215116_284759_5F8E7625)
Date: Fri, 27 Jun 2008 14:52:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>
Subject: Sparse warnings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While checking the rtl8187 driver for sparse warnings, I discovered these:

   CHECK   drivers/net/wireless/hostap/hostap_80211_rx.c
drivers/net/wireless/hostap/hostap_80211_rx.c:128:34: warning: symbol 
'hdr' shadows an earlier one
drivers/net/wireless/hostap/hostap_80211_rx.c:67:29: originally 
declared here
drivers/net/wireless/hostap/hostap_80211_rx.c:150:32: warning: symbol 
'hdr' shadows an earlier one
drivers/net/wireless/hostap/hostap_80211_rx.c:67:29: originally 
declared here
   CHECK   drivers/net/wireless/hostap/hostap_ap.c
drivers/net/wireless/hostap/hostap_ap.c:1933:18: warning: cast 
truncates bits from constant value (ffffffffffff3fff becomes 3fff)
   CHECK   drivers/net/wireless/hostap/hostap_main.c
drivers/net/wireless/hostap/hostap_main.c:597:5: warning: symbol 
'hostap_80211_header_parse' was not declared. Should it be static?

Obviously, none of these cause any problems, but I'm reporting them 
just in case.

Larry
