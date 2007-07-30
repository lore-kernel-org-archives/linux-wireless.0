Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2899 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964951AbXG3RgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 13:36:00 -0400
Date: Mon, 30 Jul 2007 10:51:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Daniel Drake <dsd@gentoo.org>, kune@deine-taler.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Message-ID: <20070730145125.GC6586@tuxdriver.com>
References: <20070730023128.99E927B409F@zog.reactivated.net> <200707292021.37845.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200707292021.37845.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 29, 2007 at 08:21:31PM -0700, Michael Wu wrote:
> On Sunday 29 July 2007 19:31, Daniel Drake wrote:
> > This patch adds debug output to mac80211 operations. This is
> > intended to sort out the issues with the interface semantics.
> >
> Ugh. I really hate enter/exit and especially these since they are open coded. 
> What do you need clarified about mac80211 interface semantics?

I agree, these are a bit ugly.  Do you intend them to be permanent?

-- 
John W. Linville
linville@tuxdriver.com
