Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50990 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0HVP5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 11:57:52 -0400
Received: by vws3 with SMTP id 3so4626813vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 08:57:51 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 22 Aug 2010 17:57:51 +0200
Message-ID: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com>
Subject: ath9k: freeze when putting interface up
From: =?ISO-8859-1?Q?Bj=F8rnar_Hansen?= <tilbjornar@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good morning

With kernel 2..6.35.2 my computer locks up when doing
  # ifconfig wlan0 up

I have now installed compat-wireless (2010-08-20), and no longer have
this problem.
I use the ath9k driver.

As this is a pretty serious problem (machine freezes completely),
would it be possible to pull some patches from compat-wireless into
the next point release of 2.6.35?


-Bjørnar Hansen
