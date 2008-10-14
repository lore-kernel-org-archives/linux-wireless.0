Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:23550 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYJNImm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 04:42:42 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1993529wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 01:42:42 -0700 (PDT)
Message-ID: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com> (sfid-20081014_104247_960957_83721B84)
Date: Tue, 14 Oct 2008 16:42:42 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: [BUG] hang with ath5k
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2.6.27 + ath5k, while using wpa_supplicant & wpa_gui system hangs
occasionally, keyboard not respond, network stop working.

There's same problem in before kernel version, but I don't know the
first version which introduce it.

The last messege on xconsole is:

disassosiating by local choice

I reproduced it by:

1) run wpa_supplicant
2) ctrl + C
3) goto 1)

-- 
Regards
dave
