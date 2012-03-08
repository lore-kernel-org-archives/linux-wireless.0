Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53280 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab2CHCDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 21:03:51 -0500
Received: by lahj13 with SMTP id j13so2863lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 18:03:50 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Mar 2012 10:03:50 +0800
Message-ID: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com> (sfid-20120308_030357_951913_297D052A)
Subject: rt8192cu on USB3
From: jerome huang <jerome.syno@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I found a problem just like in the older discussion "Question about
error from xhci-hcd",
there was a xhci error "no room on ep ring" when plugin rtl8192cu on USB3.
(it works on USB2)

After applying Larry's patch "rtlwifi: rtl8192cu: Change firmware
upload to use block writes",
I still get the same error "no room on ep ring".

But under the same compat-wireless version,
rt8712 works on USB3.

Does anyone still encounter this problem after applying this patch?
or do I miss something/patches?

BR,
Jerome
