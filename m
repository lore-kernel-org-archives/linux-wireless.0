Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753243AbdDJNwm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 09:52:42 -0400
Date: Mon, 10 Apr 2017 15:52:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3] rt2x00: reverse external PA capability flag logic
Message-ID: <20170410135239.GA8827@redhat.com> (sfid-20170410_155258_704402_8659FA86)
References: <20170410130614.GA8462@redhat.com>
 <20170410132940.GA3308@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170410132940.GA3308@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 10, 2017 at 03:29:45PM +0200, Daniel Golle wrote:
> Consequently refer to external PA instead of inverting the logic and
> use an internal PA capability flag which is a bit confusing.
> Currently this is used for Rt3352 only, but MT7620A also allows for an
> external PA which will be supported by a follow up patch.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
