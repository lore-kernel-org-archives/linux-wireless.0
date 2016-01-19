Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48938 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbcASMkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 07:40:40 -0500
Date: Tue, 19 Jan 2016 15:40:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Fariya Fatima <fariyaf@gmail.com>,
	Jahnavi Meher <jahnavi.meher@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3 3/3] rsi: Replace variable initialisations by
 assignments in rsi_send_data_pkt()
Message-ID: <20160119124006.GB6370@mwanda> (sfid-20160119_134046_396797_C646A850)
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
 <5698EE65.7010607@users.sourceforge.net>
 <5698F021.1070707@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5698F021.1070707@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Still makes no sense for adapter like Francois Romieu said.

regards,
dan carpenter

