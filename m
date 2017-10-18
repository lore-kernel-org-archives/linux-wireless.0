Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53970 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937082AbdJRKRs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 06:17:48 -0400
Message-ID: <1508321865.2674.13.camel@sipsolutions.net> (sfid-20171018_121802_907068_E361E6B9)
Subject: Re: [PATCH] fq_impl: Properly enforce memory limit
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Date: Wed, 18 Oct 2017 12:17:45 +0200
In-Reply-To: <20171016150557.19368-1-toke@toke.dk> (sfid-20171016_170633_624958_1B076FBF)
References: <20171016150557.19368-1-toke@toke.dk>
         (sfid-20171016_170633_624958_1B076FBF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-16 at 17:05 +0200, Toke Høiland-Jørgensen wrote:
> The fq structure would fail to properly enforce the memory limit in
> the case
> where the packet being enqueued was bigger than the packet being
> removed to
> bring the memory usage down. So keep dropping packets until the
> memory usage is
> back below the limit. Also, fix the statistics for memory limit
> violations.
> 
Applied.

johannes
