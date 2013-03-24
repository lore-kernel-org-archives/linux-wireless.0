Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47632 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab3CXWSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 18:18:08 -0400
Received: by mail-wi0-f179.google.com with SMTP id hn17so3365887wib.6
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 15:18:05 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC V4 0/3] mac80211: Enable VHT for non chanctxes drivers
Date: Sun, 24 Mar 2013 23:17:40 +0100
Message-Id: <1364163463-16372-1-git-send-email-karl.beldan@gmail.com> (sfid-20130324_231812_480083_2B94E417)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Hi,

In this serie, checkpatch complaints are :

- 1 "multiple assignments should be avoided" 
- numerous "line over 80 characters" in trace.h macros


Johannes, I hope this one will make it through your filter ;).
Tomorrow I will make the drivers pass, I'll send the whole serie once I have 
your go.


 
Karl
