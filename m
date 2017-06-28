Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:33897 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdF1HXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 03:23:43 -0400
Date: Wed, 28 Jun 2017 09:23:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, colin.king@canonical.com, justin@kuvee.com
Subject: Re: [PATCH v4] NFC: trf7970a: Correct register settings for 27MHz
 clock
Message-ID: <20170628071746.GL21214@zurbaran.ger.intel.com> (sfid-20170628_092416_763754_1D10407F)
References: <1493328526-28395-1-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493328526-28395-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Geoff,

On Thu, Apr 27, 2017 at 05:28:46PM -0400, Geoff Lansberry wrote:
> In prior commits the selected clock frequency does not propagate
> correctly to what is written to the TRF7970A_MODULATOR_SYS_CLK_CTRL
> register.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---
>  drivers/nfc/trf7970a.c | 7 +++++++
>  1 file changed, 7 insertions(+)
Applied to nfc-next, thanks.

Cheers,
Samuel.
