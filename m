Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36563 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121AbbFJJ0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 05:26:38 -0400
Received: by qkx62 with SMTP id 62so22017584qkx.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 02:26:37 -0700 (PDT)
MIME-Version: 1.0
From: darklight wu <darklightwu@gmail.com>
Date: Wed, 10 Jun 2015 17:26:16 +0800
Message-ID: <CALWn1pvVnNwnUZO3mEfEcJJQnQK4X8M4JGwn3+ni9m6DGkpsUQ@mail.gmail.com> (sfid-20150610_112642_371048_F81D8047)
Subject: Is it possible to work on both sta and adhoc mode on single ath PHY?
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was trying to enable both sta and adhoc mode with one atheros(ath9k)
radio through virtual interfaces but failed.

Instead, I was able to enable it work on both adhoc and ap mode. I
also got to know someone was able to have sta and ap mode work at same
time.

Anyone knows if the ath driver or hw supports working on sta and adhoc
mode simultaneously? And how to do that?

Thanks!
-dlw
