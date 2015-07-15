Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35055 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbbGOGPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2015 02:15:20 -0400
Received: by wiga1 with SMTP id a1so118492561wig.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 23:15:19 -0700 (PDT)
MIME-Version: 1.0
From: Adrien Decostre <ad.decostre@gmail.com>
Date: Wed, 15 Jul 2015 08:14:39 +0200
Message-ID: <CAOtFK_VntKh+ypx4cSJfkAudiPMN-+P=oRsmVrehMHNuQbs+Wg@mail.gmail.com> (sfid-20150715_081524_285593_9D974D88)
Subject: Wi-Fi Direct multi-role support in ath9k
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am experimenting a bit with Wi-Fi Direct on top of the ath9k driver
and I am wondering if it is possible to operate at the same moment, on
the same IEEE802.11n module, a software AP for an infrastructure Wi-Fi
network (e.g. by using hostapd) and a soft AP for a Wi-Fi Direct link.

As far as I understand, for this, the driver needs to support the
“multi-role” feature. Is it right?

Is this feature already supported by the ath9k driver?


Many thanks in advance for any help.


Best regards
