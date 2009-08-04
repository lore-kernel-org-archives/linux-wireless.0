Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:43415 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbZHDRFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 13:05:14 -0400
Received: by ewy10 with SMTP id 10so494112ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 10:05:13 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: mac80211 TX frame alignment
Date: Tue, 4 Aug 2009 19:05:11 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908041905.11632.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Do you know if for outgoing frames the header should always
be 4-byte aligned?
I have a bugreport from users claiming that master mode
is failing for rt2500pci because the beacons passed to the
driver are not 4-byte aligned which causes the device not
to send out the beacons correctly.

I'm just wondering if this is something that should be fixed
in the driver or in mac80211.

Thanks,

Ivo
