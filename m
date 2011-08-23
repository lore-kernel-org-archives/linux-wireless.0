Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32853 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab1HWOAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 10:00:14 -0400
Date: Tue, 23 Aug 2011 09:53:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [RFC][PATCH] b43: HT-PHY: allow writing longer tables with a
 single call
Message-ID: <20110823135311.GC9770@tuxdriver.com> (sfid-20110823_160019_996775_741E21A2)
References: <1313100627-26186-1-git-send-email-zajec5@gmail.com>
 <CACna6rwbzX241MVCwPd1qRbU1uWRcwjyVguBhcLs8xPcDzV0GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwbzX241MVCwPd1qRbU1uWRcwjyVguBhcLs8xPcDzV0GQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 03:44:51PM +0200, Rafał Miłecki wrote:
> W dniu 12 sierpnia 2011 00:10 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
> > Sometime we need to write table which is 2-10 elements long. It's easier
> > to create such a function instead of defining array every time.
> 
> John, take this one please.

Repost it, without "RFC" in the title.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
