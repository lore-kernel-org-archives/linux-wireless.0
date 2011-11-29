Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37628 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab1K2OpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:45:12 -0500
Received: by qadc14 with SMTP id c14so2030757qad.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 06:45:12 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 29 Nov 2011 15:45:12 +0100
Message-ID: <CAFED-jkrFehfyfwCjYxO=1r0Bu_A7KoQD4oPXvGinVSZoK3HFQ@mail.gmail.com> (sfid-20111129_154526_459350_B4B5CB55)
Subject: [question] - UAPSD QOS NULL frame seems to be queued??
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I see mac80211 send this null frame using ieee8011_send_null_response()
I am not sure I track this call correctly, but seems:

we queue this frame ( invoke_tx_handlers() != 0 ) instead of sending
directly via __ieee80211_tx(...).
Did I track this call correctly?
If yes why we queue this NULL frame?

BR
Janusz
