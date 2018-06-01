Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:52038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751293AbeFANWD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 09:22:03 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Michael Thalmeier <michael.thalmeier@hale.at>,
        linux-wireless@vger.kernel.org
Subject: [PATCH resend 0/2] NFC: pn533: Fix DMA related USB errors
Date: Fri,  1 Jun 2018 15:21:58 +0200
Message-Id: <20180601132200.25973-1-hdegoede@redhat.com> (sfid-20180601_152209_980271_5341D51E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

These 2 simple bug-fixes seem to have fallen through the cracks,
hence this resend.

Greg (gkh) despite a ping to Samuel about a month ago I still have not
had any response from the NFC people to these fixes. Since these are
really fixes for USB urb mis-handling, perhaps you can take these
upstream through the USB tree?

Regards,

Hans
