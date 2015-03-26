Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41658 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbCZSMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 14:12:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: DFS ETSI conformance for weather channels (again)
References: <773DB8A82AB6A046AE0195C68612A319019FF0E8@sbs2003.acksys.local>
	<87619nagm4.fsf@kamboji.qca.qualcomm.com>
	<000901d067e6$9f471840$ddd548c0$@acksys.fr>
Date: Thu, 26 Mar 2015 20:11:59 +0200
In-Reply-To: <000901d067e6$9f471840$ddd548c0$@acksys.fr> (Jean-Pierre Tosoni's
	message of "Thu, 26 Mar 2015 18:02:20 +0100")
Message-ID: <871tkbaas0.fsf@kamboji.qca.qualcomm.com> (sfid-20150326_191451_261718_62B48FEF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Jean-Pierre Tosoni" <jp.tosoni@acksys.fr> writes:

> I will check the wireless-regdb list instead. But it looks like the
> current python script that generates regulatory.bin was not updated
> for CAC time yet :-(

IIRC CAC patches for CRDA were not accepted or something. But it should
work with kernel internal regdb.

-- 
Kalle Valo
