Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60404 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0CEBjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 20:39:08 -0500
Date: Thu, 4 Mar 2010 20:37:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kel Modderman <kel@otaku42.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
Message-ID: <20100305013721.GA3255@tuxdriver.com>
References: <201003050008.51066.kel@otaku42.de>
 <20100304153128.GB2910@tuxdriver.com>
 <201003051027.03091.kel@otaku42.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201003051027.03091.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 05, 2010 at 10:27:03AM +1000, Kel Modderman wrote:
> On Friday 05 March 2010 01:31:28 John W. Linville wrote:
> > On Fri, Mar 05, 2010 at 12:08:50AM +1000, Kel Modderman wrote:
> > > When USE_OPENSSL=1 do not embed crypto data into binary, use the PUBKEY_DIR
> > > variable just as it is when USE_GCRYPT=1 and just load certs from PUBKEY_DIR
> > > for signature verification at runtime. Remove ssl support from
> > > utils/key2pub.py.
> > > 
> > > This allows wireless-regdb to be built from source and upgraded independently
> > > of crda and is _crucial_ for distributions who want to build their own
> > > regulatory.bin.
> > 
> > I don't understand -- isn't this possible already?
> 
> No.

Perhaps you could use a few more words?  It seems to me that what
limits you is the policies of some distributions.  Certainly crda
and wireless-regdb can be maintained separately so long as the key
doesn't change between builds or with alternate keys installed in
the proper locations.  Am I missing something?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
