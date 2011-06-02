Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46972 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab1FBAMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 20:12:39 -0400
Received: by bwz15 with SMTP id 15so497377bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 17:12:38 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 1 Jun 2011 17:12:18 -0700
Message-ID: <BANLkTimY4b0j3Wtn6JiQ6NjU53zbman76Q@mail.gmail.com> (sfid-20110602_021243_130122_9B7BC86B)
Subject: (fyi) wireless-testing.git 3.0.0-rc1 system load
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI:

If you're using John's wireless-testing.git then you'll see that your
system's load goes through the roof despite no activity. There's an
upstream patch now in Linus' repo that fixes an accounting bug in the
rcu code that will solve this:
https://github.com/mirrors/linux-2.6/commit/d72bce0e67e8afc6eb959f656013cbb577426f1e.patch

I think it's harmless, but might confuse you as it did me. It should
be fixed whenever John next does a pull and gets the above patch.

Dan
