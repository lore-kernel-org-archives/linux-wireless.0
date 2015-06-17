Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49314 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbbFQTHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 15:07:00 -0400
Message-ID: <1434568011.1884.42.camel@sipsolutions.net> (sfid-20150617_210705_231908_20E2CDA3)
Subject: Re: creating ap interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Jun 2015 21:06:51 +0200
In-Reply-To: <5581BEBA.1080500@broadcom.com> (sfid-20150617_203859_250299_EDE6A7D7)
References: <5581BEBA.1080500@broadcom.com>
	 (sfid-20150617_203859_250299_EDE6A7D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 20:38 +0200, Arend van Spriel wrote:
> Hi Dan,
> 
> When I create an AP interface using iw, it is followed by a change 
> interface back to managed mode. I added a WARN_ON to see where it came 
> from and it turns out to be the NetworkManager. However, I had disabled 
> wifi as you suggested on the mailing list once. What is your take on 
> this: bug or intentional?

You shouldn't really have a WARN_ON() on a path that can be hit by
userspace like that :)

johannes

