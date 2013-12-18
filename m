Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57897 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LRK3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 05:29:25 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so8313606pbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Dec 2013 02:29:25 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Dec 2013 15:59:25 +0530
Message-ID: <CAE2MWkn5KT7nM+RgPptbfUDVEz5KThytpNmMUzhQeP30ZSocEg@mail.gmail.com> (sfid-20131218_112936_173964_87A54C02)
Subject: P2P_DEVICE support in driver
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I want to add P2P_DEVICE support in a driver. And it's not described
in the P2P spec. So, please tell me the following points -
1> what do the driver do?
2> register_netdevice() should not be called from driver for the
P2P_DEVICE interface. Then what are the procedures (network stacks) to
add a P2P device from driver's point of view?
3> How the supplicant will communicate with this type of interface?

-- 
Thanks,
UjjaL Roy
