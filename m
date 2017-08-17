Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pv35p12im-ztdg05031101.me.com ([17.133.186.213]:38068 "EHLO
        pv35p12im-ztdg05031101.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753375AbdHRAcu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 20:32:50 -0400
Received: from process-dkim-sign-daemon.pv35p12im-ztdg05031101.me.com by
 pv35p12im-ztdg05031101.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0OUU00600S1HDC00@pv35p12im-ztdg05031101.me.com> for
 linux-wireless@vger.kernel.org; Thu, 17 Aug 2017 23:32:49 +0000 (GMT)
Received: from icloud.com ([127.0.0.1]) by pv35p12im-ztdg05031101.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) with ESMTPSA id <0OUU003B2S2MGQ00@pv35p12im-ztdg05031101.me.com> for
 linux-wireless@vger.kernel.org; Thu, 17 Aug 2017 23:32:49 +0000 (GMT)
From: =?utf-8?Q?H=C3=A5vard_Rabbe?= <hrabbe@me.com>
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: ath9k driver - is it possible to disable tx/rx radio chains?
Message-id: <0DB9FDCC-490C-438E-AA50-1C751565A9AE@me.com> (sfid-20170818_023253_784859_0F677FF9)
Date: Fri, 18 Aug 2017 01:32:44 +0200
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
I=E2=80=99m using wifi card with AR9280 chipset that uses the ath9k =
driver.

The card has 2 available radio chains and I=E2=80=99m only going to =
connect 1 antenna.

Is it possible to disable the radio chain im not using?


Best Regards,

H=C3=A5vard Rabbe=
