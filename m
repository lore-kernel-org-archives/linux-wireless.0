Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0KRH0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 02:26:22 -0500
Received: by iwn35 with SMTP id 35so3153509iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 23:26:22 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 17 Nov 2010 23:26:00 -0800
Message-ID: <AANLkTim775JXAkrvVjn-TmwD5B6-MYCRw6ah=rVF8Opk@mail.gmail.com>
Subject: module unloading busted ?
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

05:33 < mcgrof> so module unload on ath9k no longer works
06:11 < vmraj> mcgrof: module unload is not working for intel cards too
06:15 < vmraj> it can be reproduced by rmmod on active connection

I haven't yet figured out why. Anyone else with other modules experiencing this?

  Luis
