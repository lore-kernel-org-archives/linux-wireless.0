Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726960AbeGNSvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Jul 2018 14:51:23 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 4.17 REGRESSION fix 0/1] Revert "staging:r8188eu: Use lib80211 to support TKIP"
Date: Sat, 14 Jul 2018 20:31:25 +0200
Message-Id: <20180714183126.20765-1-hdegoede@redhat.com> (sfid-20180714_203134_417259_35AEA007)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

While running some ASOC tests on a VIOS LTH17 laptop I noticed that
wifi was broken and often the machine would hard freeze shortly after
bringing up the wifi connection.

One of the oopses pointed to the commit which this patch reverts and
that fixes both the wifi being broken and the hard freezes when using
the wifi.

The troublesome patch was introduced in 4.17, so this is not a 4.18
regression. Still it would be nice if we can get this fix into 4.18
before it is released.

Regards,

Hans
