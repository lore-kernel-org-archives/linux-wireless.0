Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36722 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbcIDPLq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 11:11:46 -0400
Date: Sun, 4 Sep 2016 20:41:32 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        meleodr@gmail.com, ksenija.stanojevic@gmail.com,
        Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, shivanib134@gmail.com,
        bhaktipriya96@gmail.com, bhumirks@gmail.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 1/1] drivers: staging: rtl8723au: hal: Remove
 pointless test
Message-ID: <20160904151132.GA29779@sudip-laptop> (sfid-20160904_171205_911017_6634EE8A)
References: <20160901155447.GB7979@kroah.com>
 <20160904110120.27028-2-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160904110120.27028-2-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 04, 2016 at 01:01:20PM +0200, Matthias Beyer wrote:
> This patch removes the pointless `else if` test.
> 
> Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
> Reported-by: David Binderman <linuxdev.baldrick@gmail.com>
> ---

looks like Greg has already applied your first patch.
db0c12744f8d ("drivers: staging: rtl8723au: hal: Remove pointless test")

regards
sudip
