Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1FMLAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 07:00:46 -0400
Date: Mon, 13 Jun 2011 13:00:46 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@venema.h4ckr.net,
	Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk
Subject: Re: ath9k causes lockups since kernel 2.6.35
Message-ID: <20110613110043.GA5388@redhat.com> (sfid-20110613_130049_783197_030A3BFA)
References: <20110224182022.57e32862@toddler>
 <20110224200203.GB17412@elie>
 <BANLkTik-DQxb8Ca698BeizRVyB71bWBndQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTik-DQxb8Ca698BeizRVyB71bWBndQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 02:48:00PM +0800, Adrian Chadd wrote:
> This patch against the current wireless-testing tree restores bit 6/7
> being set for the AR9285.
> 
> Tony, would you please test this out and see if this works? This is
> against the latest wireless-testing.

cam a fedora user, confirms that patch fixes the locks-ups
https://bugzilla.redhat.com/show_bug.cgi?id=697157#c26

We are waiting for fix now :-)

Thanks
Stanislaw
