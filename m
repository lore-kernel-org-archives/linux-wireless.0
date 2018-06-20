Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33196 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932077AbeFTTg5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 15:36:57 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org, tglx@linutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 0/4] wireless: Use irqsave in USB's complete callback
Date: Wed, 20 Jun 2018 21:36:44 +0200
Message-Id: <20180620193648.25136-1-bigeasy@linutronix.de> (sfid-20180620_213741_018811_B76A19D9)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is about using _irqsave() primitives in the completion callback in ord=
er
to get rid of local_irq_save() in __usb_hcd_giveback_urb().

Sebastian
