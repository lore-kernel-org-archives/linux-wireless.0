Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48930 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973Ab0CKAnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 19:43:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 16:43:01 -0800
Date: Wed, 10 Mar 2010 16:42:59 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>
CC: "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] [PATCH] ath9k: decrease size of ath9k.ko
Message-ID: <20100311004259.GD2648@tux>
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
 <20100310235220.GA7247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100310235220.GA7247@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 03:52:20PM -0800, Greg KH wrote:
> On Sun, Feb 28, 2010 at 12:56:43AM +0800, tom.leiming@gmail.com wrote:
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > The patch defines the fields of 'valid_single_stream' and 'valid' in
> > struct ath_rate_table as char type, so decrease the size of ath9k.ko
> > about 2KB.
> 
> Why would this be a -stable patch?
> 
> confused,

Its not, oh he e-mailed stable, yeah ignore.

  Luis
