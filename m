Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33875 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbcB1TxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 14:53:22 -0500
Received: by mail-wm0-f41.google.com with SMTP id p65so44006724wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 11:53:21 -0800 (PST)
Date: Sun, 28 Feb 2016 20:53:15 +0100
From: Daniel Exner <dex@dragonslave.de>
To: linux-wireless@vger.kernel.org
Cc: dex@dragonslave.de
Subject: Support P2P mode for Intel 6235 ?
Message-ID: <20160228205315.473a66ca@dragonslave.de> (sfid-20160228_205325_375601_F92DC5CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(Please keep my CC as I'm currently not subscribed)

my Ultrabook uses this chip for Wifi:
>Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)

>From the specs I found it supports WiDi and thus should support P2P
mode.

Unfortunately the wireless Wiki says "P2P (on devices driven by
iwlmvm)" and querying the device it does not advertise P2P
capability.

Is there any chance this device might gain P2P support in the future?

Greetings
Daniel
