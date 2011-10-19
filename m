Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frontend-2.servers.ua.pt ([193.136.173.3]:52702 "EHLO
	cgpmail.ua.pt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752639Ab1JSTbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 15:31:12 -0400
Received: from mail-bw0-f46.google.com (account andreprata@ua.pt [209.85.214.46] verified)
  by frontend-2.cgpmail.ua.pt (CommuniGate Pro SMTP 5.1.13)
  with ESMTPSA id 360752192 for linux-wireless@vger.kernel.org; Wed, 19 Oct 2011 20:31:11 +0100
Received: by bkbzt19 with SMTP id zt19so2506549bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 12:31:10 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?QW5kcsOpIFByYXRh?= <andreprata@ua.pt>
Date: Wed, 19 Oct 2011 20:30:50 +0100
Message-ID: <CAGEq-jBnU4gmb+A7ox3O0vwSr0HFkccEqBydH5cqNChZ_hTkDQ@mail.gmail.com> (sfid-20111019_213118_071850_6AC04F5E)
Subject: Available nl80211 multicast groups
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I saw on your code that you resolve the multicas id of several groups
for the nl80211 family /online/, like "scan" and "mlme". I'd like to
know if there are defined constants for those IDs (i'm guessing
they're not).
Also I wanted to know what other groups exist and what messages I
should expect from them (no docs, or my bad search skills?).
Is there a multicast group to get reports on link quality changes, or
similar, or is that only available through polling?

Thanks,
André Prata
