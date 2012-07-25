Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964774Ab2GYOzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 10:55:51 -0400
Received: by obbuo13 with SMTP id uo13so1172241obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 07:55:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Jul 2012 16:55:50 +0200
Message-ID: <CALBypN7BpiyRJNYzXwHEdUvSp2iB6xwx6RyP_9zUCeggJXNSdg@mail.gmail.com> (sfid-20120725_165554_719773_9D1B8622)
Subject: [NFC] nfc subsystem queries
From: Martin Fuzzey <mfuzzey@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I have a few questions about the new NFC subsystem:

1) The devices currently supported (pn533, pn544) are quite
"intelligent", in that they accept fairly high level commands (using
HCI, NCI or a chip specific USB protocol) and abstract away the
ISO1443 -3 and -4 details. There are also chips available (such as the
recent NXP CLRC663 or the older NXP MFRC531) that provide a lower
level interface and hence require a software implementation of ISO1443
-3 and -4. Are such chips within the scope of the nfc subsystem? Is
anyone currently working on or planning to work on drivers fot this
kind of chip?

2) Are there any test suites that drivers for this subsystem are
expected to pass (as there are for USB and MMC for example)?

3) Does anyone know if Android is planning to switch to the
nfc-subsystem? I know this is a bit off topic for this list but the
question was recently asked (by someone else) with no reply on
android-kernel.

Best regards,

Martin
