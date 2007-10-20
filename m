Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43545 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161AbXJTDGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 23:06:36 -0400
Message-ID: <471970BA.3080001@garzik.org> (sfid-20071020_040640_136240_52F63610)
Date: Fri, 19 Oct 2007 23:06:34 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] zd1211rw: fix a double include
References: <20071018220946.GH8510@tuxdriver.com> <11927586853636-git-send-email-linville@tuxdriver.com>
In-Reply-To: <11927586853636-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> From: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> This patch removes all double includes of the same file. This
> makes scripts/checkincludes.pl happy.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Jeff, I missed the zd1211rw hunk of the "double includes" patch.  Could
> you apply this one manually?

this does not appear to be needed, after the pull


