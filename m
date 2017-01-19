Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44160 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753217AbdASXqF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 18:46:05 -0500
Date: Thu, 19 Jan 2017 16:35:23 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin@kuvee.com
Subject: Re: [PATCH v3 1/3] NFC: trf7970a: add device tree option for 27MHz
 clock
Message-ID: <20170119233523.GA30311@animalcreek.com> (sfid-20170120_004622_715423_7C7F1944)
References: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2016 at 11:18:32PM -0500, Geoff Lansberry wrote:
> The TRF7970A has configuration options to support hardware designs
> which use a 27.12MHz clock. This commit adds a device tree option
> 'clock-frequency' to support configuring the this chip for default
> 13.56MHz clock or the optional 27.12MHz clock.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---

Acked-by: Mark Greer <mgreer@animalcreek.com>
