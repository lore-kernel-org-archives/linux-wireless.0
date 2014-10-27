Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaJ0PTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 11:19:07 -0400
Date: Mon, 27 Oct 2014 18:18:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ipw2x00: shift wrap bugs setting ->rt_tsf
Message-ID: <20141027151819.GD6890@mwanda> (sfid-20141027_161911_399285_40B06B49)
References: <20141024081534.GA11140@mwanda>
 <1414143811.15751.14.camel@perches.com>
 <20141027095243.GA6890@mwanda>
 <1414422327.8884.8.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414422327.8884.8.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gar...  I am stupid.  The original shift can't wrap.  I don't know what
I was thinking.  Sorry for the noise...

Thanks for checking me on this Joe.

regards,
dan carpenter

