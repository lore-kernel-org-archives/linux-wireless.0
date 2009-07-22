Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38221 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZGVNax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 09:30:53 -0400
Date: Wed, 22 Jul 2009 09:19:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Phattanon Duangdara <sfalpha@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Update for regulatory database on 5GHz band for Thailand (TH)
Message-ID: <20090722131957.GA5276@tuxdriver.com>
References: <f7de31c0907220607v3266710co5640389fc0ccbc22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <f7de31c0907220607v3266710co5640389fc0ccbc22@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 08:07:21PM +0700, Phattanon Duangdara wrote:
> National Telecommunication Commisions of Thailand has announce new
> regulatory about 5GHz for RLAN last year.
> 
> But I found that Linux Wireless Regulatory Database not get updated.
> 
> Reference in Thai Language:
> http://www.ratchakitcha.soc.go.th/DATA/PDF/2551/E/042/64.PDF
> (Partly in english and reference to ITU/FCC documents, I think it
> quite easy to understand)
> 
> How can this get update on Regulatory Database ?

What a beautiful font! :-)

While there is enough English/numbers there that I can probably judge
what it means, I'd feel a lot better if someone else (perhaps you)
submitted a patch against the tree here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
