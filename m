Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:4681 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbaJKRme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2014 13:42:34 -0400
Date: Sat, 11 Oct 2014 19:37:30 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Canek =?iso-8859-1?Q?Pel=E1ez_Vald=E9s?= <canek@ciencias.unam.mx>
Subject: Re: rt2x00: two candidates for -stable
Message-ID: <20141011173730.GA30840@localhost.localdomain> (sfid-20141011_194238_719105_CFC75DC8)
References: <54385907.4090003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54385907.4090003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Xose

On Sat, Oct 11, 2014 at 12:09:11AM +0200, Xose Vazquez Perez wrote:
> I think these two should be included in -stable :
> ac0372abf8524a7572a9cdaac6495eb2eba20457 support Ralink 5362
It's new chip support actually i.e. more like new feature, however
I'm ok to post it -stable. I assume this was tested on real hardware
and it works. It's a little surprise that no other changes were needed
to support this chip, but that sometimes happen :-)

> 6a06e554daef86c4e8d290284927b081fedb249e add new rt2800usb devices
No objections.

Could you post both to stable@vger.kernel.org ?

Stanislaw
