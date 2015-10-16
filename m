Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:34089 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbbJPKtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 06:49:16 -0400
Received: by ykfy204 with SMTP id y204so80983867ykf.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2015 03:49:15 -0700 (PDT)
MIME-Version: 1.0
From: Ramprasad Vempati <ramprasad.vempati@gmail.com>
Date: Fri, 16 Oct 2015 16:18:56 +0530
Message-ID: <CAB6w8env+MY_+nTr9ZEC3XQe24whCqx+ANp3UGndDruyYPRE6A@mail.gmail.com> (sfid-20151016_124926_207868_F97E3B3A)
Subject: How does tkip_mic_test work?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I understand through mac80211/cfg80211 debugfs entry, we can write
peer mac into file "tkip_mic_test" to send packet with wrong MIC.

But I'm interested in how it works, as in most of cases, hardware is
the one that typically encrypts and calculates MIC.  Does this entry
ask underlying hardware to send packet with wrong MIC?  Or does it
differently?

Thanks,
Ram
