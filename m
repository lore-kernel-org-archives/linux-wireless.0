Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60385 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYKXXVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 18:21:25 -0500
Subject: Re: wireless-regdb: flaw in general functionality
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081124231204.GN6245@tesla>
References: <492B2B74.7040404@gmail.com>  <20081124231204.GN6245@tesla>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 18:21:23 -0500
Message-Id: <1227568883.28878.15.camel@dv> (sfid-20081125_002129_460872_D604071C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-24 at 15:12 -0800, Luis R. Rodriguez wrote:

> Your point about not being able to listen is a good one, and a patch to
> update the the US in consideration of part 15 rules would be
> appreciated. Keep in mind we have flags for such things:
> 
>   -Passive scan
>   -No-IBSS
> 
> We should probably rename no-ibss to no-beaconing though as that is the
> real meaning inention behind it. 

Maybe you mean no-transmit?  I don't think seeing an AP transmitting on
a wrong frequency is an excuse for doing the same.  At least in some
jurisdictions.

-- 
Regards,
Pavel Roskin
