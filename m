Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab0FCWwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 18:52:08 -0400
Date: Thu, 3 Jun 2010 15:51:15 -0700
From: Greg KH <greg@kroah.com>
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: Switch from wext to cfg80211
Message-ID: <20100603225115.GA6986@kroah.com>
References: <1275602646.2005.13.camel@dellpc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1275602646.2005.13.camel@dellpc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 03, 2010 at 11:04:06PM +0100, Karl Relton wrote:
> Switch driver over from wext to cfg80211 interface.

Wow!  Nice job, I'll queue this up in my tree for inclusion in
linux-next after 2.6.35-rc2 comes out.

thanks,

greg k-h
