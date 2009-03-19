Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:33646 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZCSU7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 16:59:38 -0400
Message-ID: <49C2B0DD.2080209@lwfinger.net> (sfid-20090319_215946_362967_7C128E95)
Date: Thu, 19 Mar 2009 15:53:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Mask PHY TX error interrupt, if not debugging
References: <200903191927.21868.mb@bu3sch.de> <200903192013.44903.mb@bu3sch.de> <35D36C55-6CB3-443C-A916-D5771B68DD9A@ing.unibs.it> <200903192110.08437.mb@bu3sch.de>
In-Reply-To: <200903192110.08437.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> The problem is that the code basically is undocumented and we
> only write blob values to the registers. So from reading the code you won't even
> know where these values are written. But the specs give some useful hints. ;)

I might be able to help with the last part. Not everything that I know has been
put into the specs. I welcome questions.

Larry
