Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19949 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbcCROyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 10:54:05 -0400
Date: Fri, 18 Mar 2016 17:53:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/19] iwlegacy: Return directly if allocation fails in
 il_eeprom_init()
Message-ID: <20160318145326.GS5273@mwanda> (sfid-20160318_155409_955070_2C2335F7)
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <01ae52425e9dba9f82f8d107da02a0d2cd23f09d.1458262312.git.julian.calaby@gmail.com>
 <56EC057A.9000804@users.sourceforge.net>
 <CAGRGNgUY+fr2vaJ=uUhqzGRMCLmyKn+2QTJGD8copXgCYv8YPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgUY+fr2vaJ=uUhqzGRMCLmyKn+2QTJGD8copXgCYv8YPA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 19, 2016 at 01:33:16AM +1100, Julian Calaby wrote:
> Hi Markus,
> 
> On Sat, Mar 19, 2016 at 12:41 AM, SF Markus Elfring
> <elfring@users.sourceforge.net> wrote:
> >> Also remove an unused label.
> >
> > Is such a commit message a bit too short?
> 
> I don't think so, but I don't decide these sorts of things.
> 
> Does anyone else have an opinion on this?

This is certainly not something where we need to redo the patch but
since you asked for the future.  A lot of web archives put the subject
and the body of the email far apart:

http://marc.info/?l=linux-wireless&m=145826783627087&w=2

lkml.org is the same way.

It makes these types of patch descriptions awkward.

regards,
dan carpenter

