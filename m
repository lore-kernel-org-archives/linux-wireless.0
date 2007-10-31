Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.blueoakdb.com ([76.10.130.48]:3374 "EHLO
	sheldon.hillsandlakes.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754449AbXJaM3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 08:29:04 -0400
From: Pablo Sanchez <pablo@blueoakdb.com>
To: ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] iwl3945 in 2.6.24-rc1 dies under load
Date: Wed, 31 Oct 2007 08:01:22 -0400
Cc: linux-wireless@vger.kernel.org
References: <20071031005202.GA1534@elf.ucw.cz> <1193792098.9704.16.camel@debian.sh.intel.com> <20071031110511.GA2194@elf.ucw.cz>
In-Reply-To: <20071031110511.GA2194@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710310801.23005.pablo@blueoakdb.com> (sfid-20071031_122908_637263_1597DCEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 October 2007 at 7:05 am, Pavel Machek penned
about "Re: [ipw3945-devel] iwl3945 in 2.6.24-rc1 dies under load:

> rmmod/insmod w/o debug=, and ...huh... problem is _still_ away?!

At the moment I'm traveling and not using much wireless but at my
office, I've seen problems similar to what you've seen:  under load
the card halts transmitting, then after a one to two second halt, it
picks up again.

I can reproduce the problem at will.  I just learned about collecting
debug so once I'm back and settled in, I'll try and reproduce with
debug.

Perhaps the two problems are related ...

Cheers,
-- 
Pablo

