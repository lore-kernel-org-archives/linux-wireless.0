Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:48186 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYDOEYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:24:47 -0400
Received: by wa-out-1112.google.com with SMTP id m16so2863706waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 21:24:45 -0700 (PDT)
Message-ID: <9f33c5230804142124g3c8f4a0ai28a6b5117e1034c9@mail.gmail.com> (sfid-20080415_052459_149800_593C87F0)
Date: Tue, 15 Apr 2008 00:24:45 -0400
From: "cao jing" <caojing.china@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: AR5K_INT_SWBA can't generate interruption for sending beacons
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm working on mac80211 and ath5k. I found that the AR5K_INT_SWBA
interruption can't be generated. So I can't send beacons by this
interruption. Anyone knows what's going on with it?

Thank you very much!

Jing
