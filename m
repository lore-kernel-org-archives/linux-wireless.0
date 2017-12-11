Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41764 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdLKLRr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 06:17:47 -0500
Message-ID: <1512991065.26976.70.camel@sipsolutions.net> (sfid-20171211_121751_862542_C0EECC92)
Subject: Re: [PATCH 1/1] ocb: Use common freqchan helper for setting the
 operating channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter =?ISO-8859-1?Q?Gro=DFe?= <pegro@friiks.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Dec 2017 12:17:45 +0100
In-Reply-To: <20171027214302.4059-1-pegro@friiks.de>
References: <20171027214302.4059-1-pegro@friiks.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-10-27 at 23:43 +0200, Peter Große wrote:
> Simplify code by using the helper which has been introduced earlier.
> 
> Signed-off-by: Peter Große <pegro@friiks.de>
> ---
>  ocb.c | 50 ++++++++------------------------------------------

No objection to the patch, but you need to generate the diff against a
full tree (must show a/net/wireless/ocb.c in the diff header), and make
it actually applicable. I'm guessing whitespace got mangled, but this
patch doesn't apply as is.

johannes
