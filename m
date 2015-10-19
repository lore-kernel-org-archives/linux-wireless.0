Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39230 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbbJSLb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 07:31:28 -0400
Message-ID: <1445254283.3307.0.camel@sipsolutions.net> (sfid-20151019_133131_496009_204C49E3)
Subject: Re: new regdb file format
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 19 Oct 2015 13:31:23 +0200
In-Reply-To: <CAB3XZEdkpYrLXh1yTJCGA-ZGS0eRuqUhTwnD9WgZaw_g7UvioA@mail.gmail.com> (sfid-20151019_132848_630124_ACF93C4B)
References: <1444855924.3054.9.camel@sipsolutions.net>
	 <1444856468.3054.17.camel@sipsolutions.net>
	 <CAB3XZEdkpYrLXh1yTJCGA-ZGS0eRuqUhTwnD9WgZaw_g7UvioA@mail.gmail.com>
	 (sfid-20151019_132848_630124_ACF93C4B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-19 at 14:28 +0300, Eliad Peller wrote:

> while at it - is there any way to indicate exclusion of some 
> channels?
> e.g. channels 38/42 in US (the current rule is "(5170 - 5250 @ 40)",
> which doesn't seem to forbid them)
> 

Hm? Why would you want to do that, if you are allowed to use that band?

johannes
