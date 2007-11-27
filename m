Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbXK0E5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 23:57:17 -0500
Date: Mon, 26 Nov 2007 20:55:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail -
 net/wireless driver
Message-Id: <20071126205559.dfaf1a56.akpm@linux-foundation.org> (sfid-20071127_045721_290940_3792615D)
In-Reply-To: <200711262337.49178.flamingice@sourmilk.net>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<20071127023430.GA24243@bakeyournoodle.com>
	<20071126185423.9280b263.akpm@linux-foundation.org>
	<200711262337.49178.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Nov 2007 23:37:48 -0500 Michael Wu <flamingice@sourmilk.net> wrote:

> On Monday 26 November 2007 21:54:23 Andrew Morton wrote:
> > Why not just rename one of them?
> >
> Wait, why does renaming just one of them work?
> 

umm, well I assume that the failure is because we're trying to link two
identically-named symbols together?
