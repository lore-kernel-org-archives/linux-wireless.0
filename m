Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755212AbeDYQgH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 12:36:07 -0400
Date: Wed, 25 Apr 2018 18:35:59 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 2/2] usb: typec: fix formatting errors that cause build
 breakage
Message-ID: <20180425163559.GA30492@kroah.com> (sfid-20180425_183649_644629_46709CEA)
References: <20180425152617.GA5058@kroah.com>
 <20180425162540.11574-1-andresx7@gmail.com>
 <20180425162540.11574-2-andresx7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180425162540.11574-2-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2018 at 12:25:40PM -0400, Andres Rodriguez wrote:
> The ASCII art illustration should be marked as a preformatted text
> block. Otherwise the build will fail when attempting to parse it.
> 
> Fixes: bdecb33af34f ( "usb: typec: API for controlling USB ..." )
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
>  Documentation/driver-api/usb/typec.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This is already in my usb tree and will go to Linus in a day or so.

thanks,

greg k-h
