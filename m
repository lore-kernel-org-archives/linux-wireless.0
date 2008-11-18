Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:53510 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYKRUQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 15:16:49 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1555545wah.21
        for <linux-wireless@vger.kernel.org>; Tue, 18 Nov 2008 12:16:49 -0800 (PST)
Message-ID: <147a89290811181216i66a5a22cv77e6d06180b7b312@mail.gmail.com> (sfid-20081118_211653_660920_9AC85271)
Date: Tue, 18 Nov 2008 22:16:49 +0200
From: "Andy Johnson" <johnsonzjo@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: mac80211 MLME and user space
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I am trying in the last days to delve into the Linux kernel wireless stack and
  I have a really short question (nevertheless,  please consider
giving a detailed and long answer); in the
linux wireless site, it says:
"Right now the MLME is done in the kernel for station mode (STA) and
userspace for AP mode (hostapd) but our goal is to eventually move it
to userspace completely."

see: http://linuxwireless.org/en/developers/Documentation/mac80211

My question is : why?

What are the benefits of moving MLME to user space ? why not to do the
opposite, namely
move the MLME from user space (as in hostapd) to the kernel so it will
be solely in the kernel? Why not extend hostapd so it will be not in
kernel space at all but in kernel ?

As far as I understand, there is an objection for moving MLME to
kernel. For example,
I saw in a thread a few days ago:
"And there never will be since we don't want the whole AP MLME in the
kernel regardless of the driver." (Johannes Berg)
see:
http://marc.info/?l=linux-wireless&m=122657805527277&w=2

Regards,
AJhohnson
