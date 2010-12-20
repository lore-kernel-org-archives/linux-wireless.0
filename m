Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.ird.yahoo.com ([77.238.189.211]:24894 "HELO
	nm4-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752990Ab0LTVkR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 16:40:17 -0500
Message-ID: <22404.31613.qm@web29501.mail.ird.yahoo.com>
Date: Mon, 20 Dec 2010 21:34:35 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl818x: move rtl8180 and rtl8187 to separate subdirectories
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1292876752-26842-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Mon, 20/12/10, John W. Linville <linville@tuxdriver.com> wrote:

> These drivers share one header file,
> but nothing else.  Worse, both
> drivers use the rtl8225 part with different register
> settings.  The
> results has been some ugly naming -- let's simplify that.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>


Seems reasonable.


      
