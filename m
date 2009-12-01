Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:39181 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752513AbZLAIbM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 03:31:12 -0500
Message-ID: <243797.21966.qm@web23104.mail.ird.yahoo.com>
Date: Tue, 1 Dec 2009 08:31:18 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH]rtl8187:fixed kernel panic on module unload
To: =?utf-8?B?0KLRhdCw0Lkg0JrQuNGA0LjQu9C7?= <tkhai@yandex.ru>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B13FFFF.4050801@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Mon, 30/11/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Have you applied the fix in mainline commit
> 37b12dd2b07b4d7dc222a5f7f88b25cec532b2aa? It should have
> fixed this problem.

37b12dd2b07b4d7dc222a5f7f88b25cec532b2aa enters mainline at v2.6.32-rc7.

I suppose it is a question for John - wireless-testing only have the vX.Y.Z-rc* and the vX.Y.Z tags... it would be useful to have the vX.Y.Z.? maintenance release tags as well (it is a matter of knowing where to git pull?) to know if a change has gone into one of the maintenance releases.


      
