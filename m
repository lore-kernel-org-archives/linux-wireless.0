Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38015 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab0FRSCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 14:02:12 -0400
Received: by fxm10 with SMTP id 10so757577fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jun 2010 11:02:10 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 Jun 2010 14:02:10 -0400
Message-ID: <AANLkTimZTGvPuWPTXSOfOjvxzQh5tSnlqNBpueASLAUF@mail.gmail.com>
Subject: rt61pci AP performance issues
From: David Ellingsworth <david@identd.dyndns.org>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been trying unsuccessfully for some time to use a rt61pci based
wireless card as an Access Point for my network. With kernel version
2.6.32-4 (Debian version) the AP works but has intermittent problems.
Notably, that version continuously prints the message
"ieee80211_tx_status: headroom too small" to my system log and the
driver simply stops working after a random amount of time. The first
of these errors was fixed some time ago after I reported it, but the
other still remains, even with the latest wireless-testing driver, and
there's no indication as to the cause of the issue. With regards to
this issue, it appears that performance steadily drops until it
becomes unusable. With the latest wireless-testing driver I can
reliably reproduce this issue by trying to transfer a large file from
my server to a client. Any help diagnosing and correcting this issue
would be greatly appreciated.

Regards,

David Ellingsworth
