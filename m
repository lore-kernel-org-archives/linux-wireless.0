Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58909 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932447AbcILIOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 04:14:46 -0400
Date: Mon, 12 Sep 2016 10:14:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: devel@driverdev.osuosl.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2 1/6] rtl8723au: remove declaration of unimplemented
 functions
Message-ID: <20160912081451.GA27008@kroah.com> (sfid-20160912_101508_410520_BB3B7F4C)
References: <1472821069-5437-1-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472821069-5437-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 02, 2016 at 02:57:44PM +0200, Luca Ceresoli wrote:
> These functions have been declared without any implementation since
> the first commit (364e30ebd2dbaccba430c603da03e68746eb932a) and there
> has been no mention of them in following commits.
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> 
> Changes v1 -> v2:
> - improve the commit message.
> ---
>  drivers/staging/rtl8723au/include/recv_osdep.h | 3 ---
>  1 file changed, 3 deletions(-)

File is no longer in my tree.
