Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:38392 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0CAB6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 20:58:04 -0500
Received: by mail-iw0-f182.google.com with SMTP id 12so1991712iwn.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 17:58:04 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 28 Feb 2010 20:58:04 -0500
Message-ID: <33a0299c1002281758k50590f14gd03c84af2b50e5fa@mail.gmail.com>
Subject: ath9k: cannot "make", have to "make clean" first
From: Anthony Le <lazugau@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I'm using Ubuntu 9.10.
I modified a source file in ath9k driver. And then tried to do "make"
But it said: there is nothing to be done with 'all'

I have to do "make clean" and then "make" to rebuild all. And it takes
long time.

Can you tell me why? and how to overcome this?

Thanks,
Anthony.
