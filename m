Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39124 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751950AbdHHGLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 02:11:05 -0400
Date: Tue, 8 Aug 2017 08:11:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michael Skeffingfon <mike@astro.ai>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] rt2x00: Fix MMIC Countermeasures
Message-ID: <20170808061102.GA10952@redhat.com> (sfid-20170808_081109_307056_D08FE15B)
References: <20170807164736.20564-1-mike@astro.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170807164736.20564-1-mike@astro.ai>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 07, 2017 at 12:47:36PM -0400, Michael Skeffingfon wrote:
> Set RX_FLAG_DECRYPTED in case of MMIC failure so that
> ieee80211_rx_h_decrypt() doesnt drop the frame before getting to
> ieee80211_rx_h_michael_mic_verify().
> 
> Signed-off-by: Michael Skeffington <mike@astro.ai>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
