Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbbDBKHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 06:07:37 -0400
Date: Thu, 2 Apr 2015 13:07:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Piotr Witoslawski <pwitos@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	devel@driverdev.osuosl.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org,
	Yannis Damigos <giannis.damigos@gmail.com>,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers: staging: rtl8723au: fix "warning: cast to
 restricted __le16"
Message-ID: <20150402100756.GH10964@mwanda> (sfid-20150402_120752_351231_9BA7901C)
References: <20150402093748.GA24455@pwitoslawski.warsaw.osa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150402093748.GA24455@pwitoslawski.warsaw.osa>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This doesn't look right and it doesn't have a changelog explainly the
weirdness.

regards,
dan carpenter

