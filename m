Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab1BQPZO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 10:25:14 -0500
Date: Thu, 17 Feb 2011 16:25:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jack Smith <smith.jack.sidman@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wpa_supplicant and system tap
Message-ID: <20110217152520.GA2287@redhat.com>
References: <1297949294.3082.4.camel@DottleKnocker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297949294.3082.4.camel@DottleKnocker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 17, 2011 at 02:28:13PM +0100, Jack Smith wrote:
> I am trying to understand why my Wireless network connection is so
> unstable.
> 
> I was wondering if it would be worthwhile to explore what ipw2200 is
> doing by way of system tap.

I never find system-tap useful for debugging modules, adding printk
in the code, recompiling and reloading module is much faster/better
method for me instead of writing stap scripts.

> Is this a sensible approach ?
> 
> If not, can you suggest a better one.

Many modules, including ipw2200, have "debug" option, using it is a good
idea when starting debugging. At some point, when more or less problem
is localized, adding custom printk's for getting more detailed
information is usually needed as well.

Stanislaw 

