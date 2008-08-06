Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50338 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYHFAlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 20:41:06 -0400
Subject: Re: [Orinoco-devel] [PATCH 00/19] orinoco: WPA for Agere based
	cards
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <4898E668.9020604@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217822232.10989.13.camel@dv> <48978C25.601@gmail.com>
	 <1217977166.19480.2.camel@dv>  <4898E668.9020604@gmail.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 20:41:04 -0400
Message-Id: <1217983264.19480.46.camel@dv> (sfid-20080806_024109_843064_9A958B54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-08-06 at 00:46 +0100, Dave wrote:
> >> +#define DEFINE_DEFAULT_PDR(pid, length, data)				\
> >> +static const struct {							\
> >> +	__le16 len;							\
> >> +	__le16 id;							\
> >> +	u8 val[length];							\

I see, the length is variable.

> The reason for defining it in this manner is to ensure the data is
> consistent. For those that are interested, this code is at the end of
> patch 08/19.
> 
> It allows (using pid 0x0005 and dummy data as an example throughout):
> 
> DEFINE_DEFAULT_PDR(0x0005, 7, "\x00\x01\x02\x03\x04\x05\x06");
...
> Please provide an example of how you think the above could be done
> better - I've tried several things, and I still think that what is in
> the patch is the neatest.

OK, it's a good idea.

-- 
Regards,
Pavel Roskin
