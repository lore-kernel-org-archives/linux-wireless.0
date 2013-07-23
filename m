Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:40475 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab3GWQTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 12:19:10 -0400
Received: by mail-la0-f46.google.com with SMTP id es20so889121lab.5
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 09:19:09 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Jul 2013 19:19:08 +0300
Message-ID: <CANUX_P3wnH-OiH_fMPghy9E0WR38OrsboOakRO3J-koJgufznw@mail.gmail.com> (sfid-20130723_181916_676846_0700A26B)
Subject: SMPS Action in AP mode?
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to figure out what would happen if, as an AP / GO, we
would send a SMPS action frame (switch to dynamic or even static)
mac80211 would honor the action frame and configure the driver to act
accordingly.

Does anyone have any experience with this?
The spec doesn't allow it specifically, but doesn't forbid it either,
so I guess we will have all kinds of behavior out there.
What about changing the caps in the beacon on the fly?

I prefer to ask instead of getting nasty bugs in interop...

Thanks!

Emmanuel Grumbach
egrumbach@gmail.com
