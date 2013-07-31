Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:37509 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3GaS17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 14:27:59 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so916727wev.36
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 11:27:58 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 31 Jul 2013 14:27:58 -0400
Message-ID: <CAJt7DwytQzEMzn9way1z5ag-vo=GsYF72uvmAJEcJeJs=Y-hfw@mail.gmail.com> (sfid-20130731_202806_326496_0CEA19F5)
Subject: CLI scan tool needed
From: Michael McElroy <mikem388@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've done a lot of searching before posting but can't seem to find the answer.

Using the backports project, I have one of the latest ralink driver
going on an arm processor running 2.6.29 along with all nl80211 parts.
Works great, thank you! The last piece I need is to get the to SSID
list, their security protocols, and signal strength. I'm looking for
output similar to 'wilist scanning'. 'iw scan' gives a lot of info but
not quite what I need without a lot of massaging.
GUI based utilities won't work for my environment.Can anyone give me
some suggestions where to look?

Thanks,

Mike
