Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752694AbdEZK5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 06:57:54 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH resend 0/1] brcmfmac: p2p and normal ap access are not always possible at the same time
Date: Fri, 26 May 2017 12:57:46 +0200
Message-Id: <20170526105747.16874-1-hdegoede@redhat.com> (sfid-20170526_125809_454141_84636141)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a resend of a patch which I send a while ago, back then there
was some discussion to come up with a better fix, but that has not lead
to anything and the driver is still periodically spamming the logs.

As such I would like to move forward with this patch for now, which
makes no functional changes other then changing the messages in question
into debug messages when the error is -EBUSY.

Regards,

Hans
