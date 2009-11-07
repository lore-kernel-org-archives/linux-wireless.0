Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52374 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZKGNpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 08:45:06 -0500
Date: Sat, 7 Nov 2009 08:42:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Changing from Minstrel to PID
Message-ID: <20091107134224.GA25893@tuxdriver.com>
References: <1257542956.6565.2.camel@localhost.localdomain> <20091106214803.GL2782@tuxdriver.com> <1257548493.3752.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1257548493.3752.15.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2009 at 08:01:33PM -0300, Martín Ernesto Barreyro wrote:
> El vie, 06-11-2009 a las 16:48 -0500, John W. Linville escribió:
> > On Fri, Nov 06, 2009 at 06:29:16PM -0300, Martín Ernesto Barreyro wrote:
> > > Hello, I have a rtl8187 wireless card and I've allways have problems
> > > with the rate control using minstrel. So everytime my kernel updates
> > > (recently it went from 2.30 to 2.31) i have to recompile mi kernel
> > > setting pid as my default rate control algorithm.
> > > 
> > > Is there a way to change that without compiling the kernel?
> > 
> > No, but I wish there were...patches?  Anyone?
> > 
> > John
> 
> I've been searching and it seems that it could be added something like
> modprobe mac80211 rc='pid'
> 
> Would it be a good idea?

Well if you are happy with a module option, we already have
ieee80211_default_rc_algo.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
