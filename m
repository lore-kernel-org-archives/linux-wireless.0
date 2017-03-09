Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752737AbdCINFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 08:05:00 -0500
Date: Thu, 9 Mar 2017 13:58:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] rt2x00: fix TX_PWR_CFG_4 register definition
Message-ID: <20170309125849.GA32547@redhat.com> (sfid-20170309_140700_061141_6A454A0E)
References: <20170308235412.GA22227@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170308235412.GA22227@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 09, 2017 at 12:54:22AM +0100, Daniel Golle wrote:
> Some of the macros used to describe the TX_PWR_CFG_4 register accidentally
> refer to TX_PWR_CFG_3, probably a copy&paste error. Fix that.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
