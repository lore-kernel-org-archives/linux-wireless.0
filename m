Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web29520.mail.ird.yahoo.com ([77.238.189.165]:38218 "HELO
	web29520.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753018Ab0KBCmP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 22:42:15 -0400
Message-ID: <309278.75116.qm@web29520.mail.ird.yahoo.com>
Date: Tue, 2 Nov 2010 02:42:09 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
To: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-4-git-send-email-herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- On Tue, 2/11/10, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> We were using wrong address for BRSR
> (Basic Rate Set Register) while
> initializing its value, comparing with Realtek sources, for
> 8187B case.
> 
> Also, the same register is initialized in
> rtl8187b_reg_table, so remove
> the duplicate initialization from the table.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

ANAPARAM* stands for "anonymous parameters", right?  One of these days we should give them some meaningful names. 



      
