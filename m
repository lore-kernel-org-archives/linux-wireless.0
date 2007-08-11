Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:30263 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbXHKGbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 02:31:18 -0400
Received: by rv-out-0910.google.com with SMTP id k20so849386rvb
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2007 23:31:18 -0700 (PDT)
Message-ID: <65a3c8300708102331t42ce4da5kf2e3fb4a105f2f80@mail.gmail.com>
Date: Sat, 11 Aug 2007 02:31:18 -0400
From: "Christopher Bills" <cpbills@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi losing AP...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i'm using iwlwifi 1.0.0-1 on a lenovo thinkpad x61, with the Intel
4965AGN wireless card. I'm using kernel 2.6.22.2 with mac80211 v8.0.2
and from time to time i lose my connection to my Belkin (802.11b)
router. this can often be remedied by issuing the 'iwconfig wlan0
essid <ssid>' command, but is rather irritating.

is this a known issue, and if so, is there some sort of work-around? i
tried using mac80211 v9.0.4 but my kernel will not compile with that,
if that is known to fix it.

thanks in advance,

chris
