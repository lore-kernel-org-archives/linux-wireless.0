Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:60932 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbZAMBFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 20:05:48 -0500
Received: from rgminet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n0D186gd016793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 01:08:07 GMT
Message-ID: <496BE899.7010406@oracle.com> (sfid-20090113_020554_657969_25B95813)
Date: Mon, 12 Jan 2009 17:04:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Sedat Dilek <sedat.dilek@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [master-2009-01-12] compiler-error in 'drivers/net/irda/donauboe.c'
References: <2d0a357f0901121657s1ea091b6m824e8f939be2d51d@mail.gmail.com>
In-Reply-To: <2d0a357f0901121657s1ea091b6m824e8f939be2d51d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sedat Dilek wrote:
> Hi,
> 
> I could not compile latest wl.git due to problems in
> 'drivers/net/irda/donauboe.c'.
> A fix and description is given in [1].
> Hope this helps other people.
> 
> Regards,
> Sedat
> 
> [1] http://patchwork.kernel.org/patch/1791/

The patch was just merged into mainline.


-- 
~Randy
