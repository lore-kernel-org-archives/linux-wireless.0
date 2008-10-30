Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43736 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbYJ3AtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 20:49:01 -0400
Message-ID: <4909046E.109@lwfinger.net> (sfid-20081030_014908_045126_198B9581)
Date: Wed, 29 Oct 2008 17:48:46 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] rtl8187: Reduce delays to reduce startup time
References: <731229.28216.qm@web23104.mail.ird.yahoo.com>
In-Reply-To: <731229.28216.qm@web23104.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Wed, 29/10/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
>> Tested-by: Herton Ronaldo Krzesinski
>> <herton@mandriva.com.br>
> 
> Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> 
> 
> 
> Seems to work just as well for me as well.

Thanks for the testing. Since I posted the patch this morning, I have located
some other speedups. I also refactored the patches to split the functionality.
There is a further speedup in initialization.

Larry
