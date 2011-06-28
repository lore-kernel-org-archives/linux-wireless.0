Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39860 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1F1T7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 15:59:05 -0400
Received: by vws1 with SMTP id 1so412440vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 12:59:04 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 Jun 2011 14:59:04 -0500
Message-ID: <BANLkTi=oxo6ryCaJZiF9NZSV7hA1DJqqSw@mail.gmail.com> (sfid-20110628_215919_478309_3D203DC2)
Subject: STA Driver/MLME handling for broadcast DEAUTHENTICATE from AP
From: alfred steele <alfred.jaquez@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI all,
I have a quick question. How should be a broadcast deauthenticate from
an AP handled by a client driver and or MLME.
Is it the same way as a unicast deauth is ahandled.
We have a case here where the AP sends a broadcast DEAUTH to the
client, but l;ooks like the driver does not report it to the WPA
supplicant event interface in the form of a DISCONNECT or a 4 -way
handhake fail etc.?
Is it supplicant problem or a driver/firmware issue or  an AP should
not be sending Bcast Death anyway?
Thanks,
Munro
