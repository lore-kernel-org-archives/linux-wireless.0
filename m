Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55336 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2I1JA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 05:00:58 -0400
Received: by obbuo13 with SMTP id uo13so2688020obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2012 02:00:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348758768-5228-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348758768-5228-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Fri, 28 Sep 2012 11:00:57 +0200
Message-ID: <CAOpc7mF8XTnW5gh7hnN=7e_M7f=wRVuPqT_7S9k2YN7tq4YXBw@mail.gmail.com> (sfid-20120928_110102_768001_2CB51076)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Ensure we set FTP_STOMP_LOW weight
 when WLAN is idle
From: Holger Schurig <holgerschurig@gmail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mohammed@venema.h4ckr.net, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> We WLAN is idle we can some better bandwidth to FTP by
> setting STOMP_LOW_FTP where stomping the FTP BT is pretty
> much reduced when compared to setting STOMP_LOW weight.

I understand that english isn't your first language (and neither is it
mine). But this is quite unintelligible.

Beside wrong words (We/When) it doesn't also really say what is going
on. What, for example, is FTP ?  How can you assume that this is
generally known?  For sure it's not the file transfer protocol. Same
with "FTP BT".

Also, "we can some better bandwidth" misses a verb. "take into account
of data packets" is weird, too.

Confused.
