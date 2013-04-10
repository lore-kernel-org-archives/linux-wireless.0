Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f181.google.com ([209.85.210.181]:53468 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935235Ab3DJOj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 10:39:57 -0400
MIME-Version: 1.0
Date: Wed, 10 Apr 2013 16:39:56 +0200
Message-ID: <CAFSJ42a2iTUxt4PytZHAQ2hbNV=PTsedrjUVuSTa5x_qvBF3sw@mail.gmail.com> (sfid-20130410_164000_526787_319740B5)
Subject: Build error: net/mac80211/tx.c:2098:26: error: 'ETH_P_802_3_MIN' undeclared
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

While building latest compat-drivers for android/cyanogenmod kernel
version 3.0.60 build fails with the following error:

/compat-drivers/net/mac80211/tx.c:2098:26: error: 'ETH_P_802_3_MIN'
undeclared (first use in this function)

As far as i understand latest kernel has define ETH_P_802_3_MIN but
old kernels(including 3.0.60) do not have this define.
Maybe this define should be added to the compat to avoid such a build
error with old kernels? Any ideas are really appreciated?

--
Best regards,
Eugene
