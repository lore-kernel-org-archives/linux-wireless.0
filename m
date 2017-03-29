Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36306 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbdC2Uou (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 16:44:50 -0400
Date: Wed, 29 Mar 2017 22:44:40 +0200
From: Johan Hovold <johan@kernel.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Vincent Cuissard <cuissard@marvell.com>
Subject: Re: [PATCH 3/7] NFC: nfcmrvl: do not use device-managed resources
Message-ID: <20170329204440.GF15708@localhost> (sfid-20170329_224659_312330_4919EA94)
References: <20170329162112.18121-1-johan@kernel.org>
 <20170329162112.18121-4-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170329162112.18121-4-johan@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 29, 2017 at 06:21:08PM +0200, Johan Hovold wrote:
> This specifically fixes a NULL-pointer dereference when using the n_nci
> line discipline on one end of a Unix98 pty as well as resource leaks in
> the registration error paths.

I noticed I forgot to actually fix up the error paths, so will send a v2
tomorrow.

Johan
