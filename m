Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50846 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbcCRLCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 07:02:03 -0400
Date: Fri, 18 Mar 2016 14:01:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Nicolas Pitre <nico@linaro.org>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH CONTROVERSIAL 19/19] iwlegacy: Rename label in
 il_eeprom_init()
Message-ID: <20160318110134.GR5273@mwanda> (sfid-20160318_120208_729495_C3DC674B)
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <90fe6325e407d35a18fa8c8cb7eaa269968d6426.1458262312.git.julian.calaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <90fe6325e407d35a18fa8c8cb7eaa269968d6426.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 01:29:39PM +1100, Julian Calaby wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> 
> Rename a jump label according to the current Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> [Rewrote commit title]
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> 
> ---
> 
> This was controversial when introduced, however the change is obvious and
> harmless and is, in the worst case, just churn.
> 
> I'm only including this as it meets my criteria for sheparding pending
> patches: it's sane, obviously correct or reviewable by me, and doesn't
> require any work to apply.
> 
> This does meet those requirements, however given how controviersial it was
> when introduced, I'm not expecting people to be enthusiastic about
> applying it.
> 
> Thanks,

It's a bad idea to mark this sort of patch as controversial.  It's
bikeshed stuff.  Either apply it or don't but don't lets spend any more
time thinking about it.

Actual controversial patches have a long term impact.

regards,
dan carpenter

