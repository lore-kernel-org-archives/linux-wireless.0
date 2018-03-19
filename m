Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967586AbeCSSpr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 14:45:47 -0400
Date: Mon, 19 Mar 2018 19:45:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: hariprasath.elango@gmail.com
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] staging: wilc1000: replace switch statement by
 simple if condition
Message-ID: <20180319184546.GA17337@kroah.com> (sfid-20180319_194608_903378_EB8F6B43)
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
 <2a46a5cc8ab69c1143c480bbac1f7e921011d982.1521030891.git.hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2a46a5cc8ab69c1143c480bbac1f7e921011d982.1521030891.git.hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2018 at 06:15:03PM +0530, hariprasath.elango@gmail.com wrote:
> From: HariPrasath Elango <hariprasath.elango@gmail.com>
> 
> In this case,there is only a single switch case statement.So replacing
> by a simple if condition.
> 
> Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Does not apply to my tree :(
