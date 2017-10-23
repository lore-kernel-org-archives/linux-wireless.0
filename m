Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43318 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdJWGsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 02:48:23 -0400
Message-ID: <1508741298.2639.7.camel@sipsolutions.net> (sfid-20171023_084841_704106_A901FAB2)
Subject: Re: [PATCH] net: wireless: mark expected switch fall-throughs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 23 Oct 2017 08:48:18 +0200
In-Reply-To: <20171020172145.GA5366@embeddedor.com>
References: <20171020172145.GA5366@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-10-20 at 12:21 -0500, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
> This code was tested by compilation only (GCC 7.2.0 was used).
> Please, verify if the actual intention of the code is to fall through.

Please, if you're proposing patches, do that yourself.

johannes
