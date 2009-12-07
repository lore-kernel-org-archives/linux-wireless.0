Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f197.google.com ([209.85.212.197]:55241 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZLGGVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 01:21:24 -0500
Received: by vws35 with SMTP id 35so1915868vws.4
        for <linux-wireless@vger.kernel.org>; Sun, 06 Dec 2009 22:21:30 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Dec 2009 11:51:30 +0530
Message-ID: <d9360e520912062221o1f543bc9tbe3813113562a25d@mail.gmail.com>
Subject: ssid
From: Bharat Bhushan <bharat.b.bhushan@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello gentlemen,

                         i am trying to implement an open source mac
base driver with kernel base version 2.6.29, for association
completion my hardware requires an api with ssid to be sent. but i
could not find any api from mac80211.h which contain ssid element
except hw_scan which i cannot use as ssid should be sent before
association ,few days back i implement the same driver with kernel
version 2.6.27 and i use to get ssid in ieee80211_if_conf structure in
config_interface api but now this is deprecated , any particular
reason why this change happen, is there any other way i can get ssid
through any interface.



Any help is much appreciated.


Thanks

bharat
