Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35730 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3EVTPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 15:15:14 -0400
Date: Wed, 22 May 2013 15:01:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stf_xl@wp.pl
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	gwingerde@gmail.com, ivdoorn@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 00/32] BBP initialization split
Message-ID: <20130522190145.GJ2113@tuxdriver.com> (sfid-20130522_211531_984227_B1EF27E9)
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 18, 2013 at 02:03:23PM +0200, stf_xl@wp.pl wrote:
> This series spits big and messy rt2800_init_bbp() procedure into small
> per chip (or few similar chips) subroutines.

Lots of refactoring here -- I trust Stanislaw, but it might be nice
to see an ACK from Gertjan, Helmut, and/or Ivo?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
