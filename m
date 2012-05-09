Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2EIG27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 02:28:59 -0400
Received: by pbbrp8 with SMTP id rp8so88197pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 23:28:59 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 May 2012 14:28:59 +0800
Message-ID: <CAFCUKTSjvKk3DPfjkYUQ+zc=81OFF8hfJ6gzbYe+V-jA9FjSwA@mail.gmail.com> (sfid-20120509_082918_282199_67CF9480)
Subject: If AP mode with MLME/SME implemented in firmware gets supported in
 linux 3.0
From: harvey yang <harvey.huawei.yang@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I am working on a fullmac driver using cfg80211, which has AP mode
with MLME/SME implemented in firmware. I want to port it to linux 3.0
to work with android , but I am afraid that the kernel do not support
this kind of implementation and it will not work with hostapd
properly. I am not sure about that, could you please give me some
hints?

Thanks
Harvey
