Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751316AbZI2I6n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 04:58:43 -0400
From: Malte Gell <malte.gell@gmx.de>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need help to create driver for Netgear WN111v2
Date: Tue, 29 Sep 2009 10:58:43 +0200
Cc: ndiswrapper-general@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
References: <999306.93095.qm@web23102.mail.ird.yahoo.com>
In-Reply-To: <999306.93095.qm@web23102.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909291058.43765.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


"Hin-Tak Leung" <hintak_leung@yahoo.co.uk> wrote
 
> Hmm, I see you have already posted to linux-wireless and already got your
>  answers. Hauke has already given you the answer - your kernel tree is
>  *not* 2.6.27(.0), and as it is obvious that you have 2.6.27.29-0.1, which
>  is 2.6.27.29 + suse-patches. Even 2.6.27.29 is not 2.6.27(.0), but
>  somewhat closer to 2.6.28. And you really have already had your answer -
>  your tree is somewhat between 2.6.27 and 2.6.28, and *neither*.
> 
> My suggestion would be simply to delete all the 'error: redefinition' parts
>  from net/compat-2.6.28.h , because you already have them in the suse tree.

Thanx for your efforts. By the way, do I need to set  CONFIG_TRACEPOINTS in the 
kernel? I just see it is _not_ set in openSUSE 11.1.

>  You may also need to delete something from net/compat-2.6.28.c, but that
>  will happen during the linking stage (much later).

So, no need to modify compat-2.6.28.c? Does it automatically happen?

Regards
Malte
