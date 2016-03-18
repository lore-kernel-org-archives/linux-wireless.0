Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbcCRKdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 06:33:42 -0400
Date: Fri, 18 Mar 2016 11:31:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Nicolas Pitre <nico@linaro.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH CONTROVERSIAL 19/19] iwlegacy: Rename label in
 il_eeprom_init()
Message-ID: <20160318103124.GC24990@redhat.com> (sfid-20160318_113356_989317_14E45770)
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

I don't see the sense of that change, NACK

Stanislaw


