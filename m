Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39118 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0KKPrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 10:47:39 -0500
Received: by ewy7 with SMTP id 7so1182884ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 07:47:38 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Nov 2010 21:17:38 +0530
Message-ID: <AANLkTi=JeW0t31EW9SJqRnrJZMUab6Ew6PF+D19n6QQQ@mail.gmail.com>
Subject: wl1271 clock query
From: Sriram V <vshrirama@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
  I am trying to read the Manf. ID of 1271 module. I have seen that if
i go above 4MHZ all sdio commmads to read the manf. tuple fails.
  I get commands CRC errors.

  Are there any limitations far as clock frequency is concerned for
reading the manf. ID?

 Should the clock be 400K or above? Any thoughts on this?

Regards,
sriram
