Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61939 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1KFAxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Nov 2011 20:53:45 -0400
Received: by vws1 with SMTP id 1so2857553vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Nov 2011 17:53:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 6 Nov 2011 02:53:43 +0200
Message-ID: <CAFtRNNwXdeBfa-mFNyAVALgTxM-wrUthgMLS18VokqOSSiWPqg@mail.gmail.com> (sfid-20111106_015359_593392_B23322E1)
Subject: 802.11p implementation...
From: Nick Kossifidis <mickflemm@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems a group of people have released an 802.11p implementation on
top of 2.6.31.

http://www.gcdc.net/mainmenu/Home/downloads/Technology

>From a quick look changes on the kernel part are minimal, they moved
most of their work on userspace.
Also the ath5k related part is already upstream (half/quarter rate support).

Could we get this upstream and merge it with current tools ? How does it look ?

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
