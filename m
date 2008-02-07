Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051AbYBGVaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 16:30:16 -0500
Date: Thu, 7 Feb 2008 13:27:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux@arm.linux.org.uk, deller@gmx.de, jt@hpl.hp.com, rjw@sisk.pl,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-Id: <20080207132717.8e9066a7.akpm@linux-foundation.org> (sfid-20080207_213027_220872_150CF62F)
In-Reply-To: <20080207204601.GD3025@tuxdriver.com>
References: <200801131516.34567.deller@gmx.de>
	<20080202224515.20a09553.akpm@linux-foundation.org>
	<200802062150.23930.deller@gmx.de>
	<20080206130448.564f18bb.akpm@linux-foundation.org>
	<20080206214747.GG32245@flint.arm.linux.org.uk>
	<20080206135950.d48ffa36.akpm@linux-foundation.org>
	<20080207155152.GA3025@tuxdriver.com>
	<20080207104912.c719deed.akpm@linux-foundation.org>
	<20080207190842.GC3025@tuxdriver.com>
	<20080207120238.d169a0d2.akpm@linux-foundation.org>
	<20080207204601.GD3025@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 7 Feb 2008 15:46:01 -0500
"John W. Linville" <linville@tuxdriver.com> wrote:

> > fixes things up.  If forces `union hacs_u' to be two bytes, not four.
> 
> OK, so I'll queue this one...'salright?

yup, that compiles OK for me.
