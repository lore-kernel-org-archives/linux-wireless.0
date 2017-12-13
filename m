Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35844 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753054AbdLMNAI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 08:00:08 -0500
Message-ID: <1513170005.26976.87.camel@sipsolutions.net> (sfid-20171213_140023_231958_8DF89D20)
Subject: Re: [PATCH] ocb: Use common freqchan helper for setting the
 operating channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter =?ISO-8859-1?Q?Gro=DFe?= <pegro@friiks.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Dec 2017 14:00:05 +0100
In-Reply-To: <20171213125840.1036-1-pegro@friiks.de>
References: <1512991065.26976.70.camel@sipsolutions.net>
         <20171213125840.1036-1-pegro@friiks.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-12-13 at 13:58 +0100, Peter Große wrote:
> Simplify code by using the helper which has been introduced earlier.
> 
> Signed-off-by: Peter Große <pegro@friiks.de>
> ---
> 
> Mh, the patch is against the full tree of iw, not the kernel, so there is no
> net/wireless/ path.

D'oh! I guess you should've mentioned "iw" somewhere - I actually tried
to apply it to the kernel tree :)

johannes
