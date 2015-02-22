Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38457 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbBVUBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 15:01:33 -0500
Received: by iecrd18 with SMTP id rd18so18973302iec.5
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 12:01:32 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 22 Feb 2015 12:01:32 -0800
Message-ID: <CAJ-Vmo=4-SwXEHV2aNAErFvRCxEj=a8a30Du+VdwRq_31xxqAg@mail.gmail.com> (sfid-20150222_210137_366907_DB2693CE)
Subject: Please test: ath9k-htc 1.4 firmware images
From: Adrian Chadd <adrian@freebsd.org>
To: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I've rolled some updated firmware images for ath9k-htc:

https://people.freebsd.org/~adrian/ath9k_htc/1.4/

I'd like to get some wider testing before I submit them to
linux-firmware.git for inclusion.

So please test them out and let me know if they do / don't work for
you. Outside of a couple of new things to support mesh better, it's
mostly lots of bug fixes and preparation for further improvements.

Thanks!


-adrian
