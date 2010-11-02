Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47828 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0KBBAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:00:11 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 0/9] rtl8187: start cleanup/revisiting code
Date: Mon,  1 Nov 2010 22:59:30 -0200
Message-Id: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While looking at rtl8187 driver I noticed possible cleanups and found 2
bugs (last 2 patches in the series). This series presents the changes.
I didn't finished revisiting everything, so there are more cleanups
possible, but for now the 2 bug fixes are worth the initial submit.

--
[]'s
Herton
