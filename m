Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:63896 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaBRMOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 07:14:39 -0500
Received: by mail-we0-f182.google.com with SMTP id u57so11415932wes.41
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 04:14:38 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 18 Feb 2014 17:44:38 +0530
Message-ID: <CADNhdGEVUK5rJBisaAYQXfWBUBz+KkSHb5JSRtK4JuALOad+WA@mail.gmail.com> (sfid-20140218_131500_554547_433D4D06)
Subject: mac80211 support for RTL chipset
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to install and get an USB WiFi dongle in AP ("Master")
mode on linux kernel 3.3.4.

I am not able to get the device to work with mac80211 / cfg80211
driver --> iw does not work but iwconfig works.

Do you know if the RTL 8188CUS and RTL 8188EUS chipsets support mac80211?

Please clarify and help.

regards,
-shankar
