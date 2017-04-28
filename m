Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49635 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030294AbdD1A2o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 20:28:44 -0400
Date: Thu, 27 Apr 2017 17:28:42 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com, colin.king@canonical.com,
        wharms@bfs.de
Subject: Re: [PATCH v4] NFC: trf7970a: Correct register settings for 27MHz
 clock
Message-ID: <20170428002842.GA26631@animalcreek.com> (sfid-20170428_022913_800986_F2F06EC5)
References: <1493328526-28395-1-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493328526-28395-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 27, 2017 at 05:28:46PM -0400, Geoff Lansberry wrote:
> In prior commits the selected clock frequency does not propagate
> correctly to what is written to the TRF7970A_MODULATOR_SYS_CLK_CTRL
> register.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---

Acked-by: Mark Greer <mgreer@animalcreek.com>
