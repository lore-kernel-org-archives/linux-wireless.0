Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEHO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 03:14:27 -0400
Message-ID: <1373008459.8548.0.camel@jlt4.sipsolutions.net> (sfid-20130705_091430_963795_5F0E7536)
Subject: Re: [PATCH] include: net: Add parameter desc to fix warning when
 generating docs
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Bristow <sam.bristow@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Fri, 05 Jul 2013 09:14:19 +0200
In-Reply-To: <1372972701-18323-1-git-send-email-sam.bristow@gmail.com> (sfid-20130704_231857_967925_7DC3A375)
References: <1372972701-18323-1-git-send-email-sam.bristow@gmail.com>
	 (sfid-20130704_231857_967925_7DC3A375)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-05 at 09:18 +1200, Sam Bristow wrote:
> 'make htmldocs' was generating a warning about a missing parameter description
> for gfp.

Thanks, but I already have it in my tree. Also, you forgot to sign off
on the patch anyway.

johannes

