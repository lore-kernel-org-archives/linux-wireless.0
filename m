Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62040 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbYLAWjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 17:39:09 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 14:39:09 -0800
Date: Mon, 1 Dec 2008 14:39:07 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Diego 'Flameeyes' =?iso-8859-1?Q?Petten=F2?= <flameeyes@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [crda PATCH 1/3] Move is_valid_reg_rule() in intersect.c.
Message-ID: <20081201223907.GR5992@tesla> (sfid-20081201_233913_406765_81ADD540)
References: <20081201122657.20222.49058.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20081201122657.20222.49058.stgit@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 04:26:57AM -0800, Diego 'Flameeyes' Petten=F2 w=
rote:
> The function is only ever used in that translation unit so it makes n=
o
> sense to define it for all the binaries.

I was planning on using is_valid_reg_rule() before sending the reg rule
but sure, this is good for now. All 3 patches applied, thanks.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
