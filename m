Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41463 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3FEAtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 20:49:08 -0400
Received: by mail-qa0-f50.google.com with SMTP id l18so136778qak.9
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 17:49:07 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Jun 2013 17:49:07 -0700
Message-ID: <CAJ-Vmo=2oBy7kVN5dTx1TLfEER77tOYQXTz6WoG6Q=4A0kOgmw@mail.gmail.com> (sfid-20130605_024912_062818_EB1FC871)
Subject: 4.9GHz and 5.8GHz regulatory entries?
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm hacking at the support needed for 4.9 and 5.8GHz NICs in FreeBSD.
Well, there's support for them (and they work!) but I'm doing up some
regulatory entries for them.

So, has anyone looked at adding 4.9 and 5.8GHz regulatory domain
entries to db.txt in Linux, for regulatory domains that allow them to
be used unlicenced?

Thanks,



Adrian
