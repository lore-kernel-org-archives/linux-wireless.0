Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36109 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYKZAf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 19:35:56 -0500
Subject: Re: wireless-regdb: flaw in general functionality
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081126001942.GN5950@tesla>
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla>
	 <1227568883.28878.15.camel@dv>
	 <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com>
	 <492B623E.5030202@gmail.com> <1227580299.32415.2.camel@dv>
	 <20081126001942.GN5950@tesla>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 19:35:54 -0500
Message-Id: <1227659754.2556.11.camel@dv> (sfid-20081126_013605_909093_BC4E48ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-25 at 16:19 -0800, Luis R. Rodriguez wrote:

> This is documented here:
> 
> http://wireless.kernel.org/en/developers/Regulatory#Changingthedatabasefileformat

I mean, I don't know how painful it can be.  Perhaps it's better to
anticipate some requirements earlier than to change them later.  I think
both "don't transmit" and "don't transmit unless permitted by the AP"
could be useful in some jurisdictions.

-- 
Regards,
Pavel Roskin
