Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47070 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbeHXPHm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 11:07:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: verify evt type in usb mcu response
References: <cover.1535106415.git.lorenzo.bianconi@redhat.com>
        <56664707fd600dc2ff49c6e845b0d573a9cf9c89.1535106415.git.lorenzo.bianconi@redhat.com>
Date: Fri, 24 Aug 2018 14:33:24 +0300
In-Reply-To: <56664707fd600dc2ff49c6e845b0d573a9cf9c89.1535106415.git.lorenzo.bianconi@redhat.com>
        (Lorenzo Bianconi's message of "Fri, 24 Aug 2018 12:41:44 +0200")
Message-ID: <87k1ogt2wr.fsf@purkki.adurom.net> (sfid-20180824_133330_498255_34C9F0C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Verify if evt field is set to EVT_CMD_DONE in usb mcu
> response messages
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Does this fix a real bug or is it just a cleanup? To which tree it
should go?

-- 
Kalle Valo
