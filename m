Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:18320 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1BBJwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 04:52:08 -0500
Date: Wed, 2 Feb 2011 10:44:09 +0100 (CET)
From: Prigent Xavier MAPS LIS LANNION <labolis2@orange.fr>
Reply-To: Prigent Xavier MAPS LIS LANNION <labolis2@orange.fr>
To: linux-wireless@vger.kernel.org
Message-ID: <10052860.45456.1296639849605.JavaMail.www@wwinf1e10>
Subject: =?UTF-8?Q?HOW_TO_enable_UAPSD_and_WMM_=C2=A0on_ath9k?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello ALL,

I have an AR9280 on debian version 2.6.32. I tried to enable UAPSD and WMM on all queue but I can not. I install compat-
wirelless and load ath9k. 
I saw with iw you can 't enable wmm or UAPSD. I remenbered with iwpriv you could do this but it does not work with this 
driver. 
I saw on" http://wireless.kernel.org/en/developers/Documentation/kerneldoc/include/net/mac80211.h" you could change WMM 
and UAPSD value.So I decide to make change in source and header code 
but it seems to be difficult and I does not understand all.
* @IEEE80211_HW_SUPPORTS_UAPSD:
* Hardware supports Unscheduled Automatic Power Save Delivery
* (U-APSD) in managed mode. The mode is configured with
* conf_tx() operation.

where is conf_tx() operation?

Where I have to make change in order to enable WMM and UAPSD on all queue? 
Is there a CLI command? 

Thanks for your help,

PX
