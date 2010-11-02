Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47236 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0KBBDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:03:01 -0400
Message-ID: <4CCF6332.1080902@mandriva.com.br>
Date: Mon, 01 Nov 2010 23:02:42 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 0/9] rtl8187: start cleanup/revisiting code
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01-11-2010 22:59, Herton Ronaldo Krzesinski wrote:
> Hi,
>
> While looking at rtl8187 driver I noticed possible cleanups and found 2
> bugs (last 2 patches in the series). This series presents the changes.
> I didn't finished revisiting everything, so there are more cleanups
> possible, but for now the 2 bug fixes are worth the initial submit.

Sorry, forgot to add that this series should be applied after "rtl8187b: 
do not do per packet TX AGC" posted last week on linux-wireless (first 
patch probably will conflict/not apply without it).

--
[]'s
Herton
