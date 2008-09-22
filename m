Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48268 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbYIVWO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 18:14:29 -0400
Date: Mon, 22 Sep 2008 18:13:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: akpm@linux-foundation.org
Cc: linux-wireless@vger.kernel.org, born.into.silence@gmail.com,
	dsd@gentoo.org, johannes@sipsolutions.net, kune@deine-taler.de
Subject: Re: [patch 1/1] wireless: zd1211rw: add device ID fix wifi dongle
	"trust nw-3100"
Message-ID: <20080922221359.GG3660@tuxdriver.com> (sfid-20080923_001432_088438_68869EC6)
References: <200809222201.m8MM1pBH032706@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809222201.m8MM1pBH032706@imap1.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 03:01:51PM -0700, akpm@linux-foundation.org wrote:
> From: <born.into.silence@gmail.com>
> 
> akpm: taken from http://bugzilla.kernel.org/show_bug.cgi?id=11587
> 
> I bought the wifi dongle trust nw-3100 wich is in fact a zd1211rw.  Its
> hardware id was missing in the sources, adding it made it work flawlessly.
> 
> Cc: Daniel Drake <dsd@gentoo.org>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Just sent a pull request to Dave with this one in it...thanks!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
