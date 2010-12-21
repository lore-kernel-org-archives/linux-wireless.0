Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47043 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab0LUWpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 17:45:05 -0500
Date: Tue, 21 Dec 2010 17:32:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] b43: N-PHY: update 2056 radio on channel switch on
 rev3+
Message-ID: <20101221223250.GA10046@tuxdriver.com>
References: <1292956819-21166-1-git-send-email-zajec5@gmail.com>
 <1292956819-21166-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1292956819-21166-2-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 21, 2010 at 07:40:19PM +0100, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> John: I ignored over 80 chars warnings, as this is very simple code
> (write-by-write, line-by-line) and I believe this can improve readibility.

Not if you are looking at it with line breaks...

Do you really object to breaking a function call at its third
parameter?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
