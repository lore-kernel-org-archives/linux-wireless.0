Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:60932 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753295AbYHTRAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2008 13:00:32 -0400
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/1] =?UTF-8?Q?toshiba=5Facpi=3A=20Add=20support=20for=20bluet?=
 =?UTF-8?Q?ooth=20toggling=20through=20rfkill=20=28v=36=29?=
MIME-Version: 1.0
Date: Wed, 20 Aug 2008 13:01:09 -0400
From: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, linux-wireless@vger.kernel.org
In-Reply-To: <200808201757.04501.IvDoorn@gmail.com>
References: <200808201757.04501.IvDoorn@gmail.com>
Message-ID: <8a2829c23d0739b82cf8bb7c7b80e6c4@localhost> (sfid-20080820_190038_289533_0C0DBC4E)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 20 Aug 2008 17:57:04 +0200, Ivo van Doorn <ivdoorn@gmail.com>
wrote:
> 
> This looks very nice, but is the switch really toggling between
> soft and hard blocked only? ;)
> 
> I mean shouldn't there be some unblock signal at some point?

Nope :-)

There is no hardware mechanism to actually turn the bluetooth adapter on;
that's
why driver support has been so important for poor toshiba users; without it
the
adapter is completely useless. On windows, toshiba provide a special
program to
do this as well. It's all very odd.

--phil

