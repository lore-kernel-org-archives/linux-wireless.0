Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33710 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbZFQTAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 15:00:33 -0400
Date: Wed, 17 Jun 2009 14:58:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: jouni.malinen@atheros.com, luis.rodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 0/7] ATH9K bug fixes - TX hang & Signal Quality issue
Message-ID: <20090617185852.GD2791@tuxdriver.com>
References: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 09:55:25PM +0530, Senthil Balasubramanian wrote:
> This seris fixes couple of important issues
> 
> 1) Signal Quality issue (patch 1/7)
> 2) INI update - fixes performance issue (Patch 2/7)
> 3) TX hang issue (happens after an hour time, Patch 6/7 & 7/7)

I'm sorry, but the changelog entries for those patches is
insufficiently detailed -- especially if you want them merged as
fixes for 2.6.31.  I need a report with enough details for the fix
to be properly evaluated and preferably a link to an actual bug report.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
