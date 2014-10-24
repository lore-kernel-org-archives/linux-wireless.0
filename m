Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48606 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbaJXPYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 11:24:15 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so1565627wiv.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 08:24:14 -0700 (PDT)
MIME-Version: 1.0
From: Adrien Decostre <ad.decostre@gmail.com>
Date: Fri, 24 Oct 2014 17:23:33 +0200
Message-ID: <CAOtFK_Ue0xjEaYY3qm0n2Tj=Hnu1dbphupmdZmiouVuGLnktoA@mail.gmail.com> (sfid-20141024_172420_373480_F824C2D6)
Subject: Questions regarding ath9k and new EN 300 328 regulation
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,



I am looking for information about the compliancy of the ath9k driver
to the EN 300 328 ETSI regulation.

Would someone know if ath9k has already been tested for this regulation?

Is it needed to enable any specific flag in ath9k to guarantee
compliancy to the adaptivity tests described in EN 300 328?



I already tried by applying the patches “ath9k: Fix regulatory
compliance” (http://www.spinics.net/lists/linux-wireless/msg115798.html)
 and “ath9k: Fix ETSI compliance for AR9462 2.0”
(http://www.spinics.net/lists/linux-wireless/msg118665.html) but this
does not seem to be sufficient.



Many thanks in advance for any help



Best regards
