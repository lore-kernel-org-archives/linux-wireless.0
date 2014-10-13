Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:37942 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaJMJqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 05:46:01 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local> <CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>
In-Reply-To: <CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>
Subject: RE: ath10k firmware crash
Date: Mon, 13 Oct 2014 11:23:36 +0200
Message-ID: <024a01cfe6c7$5e427dd0$1ac77970$@acksys.fr> (sfid-20141013_114606_102436_9991829D)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> 
> Are you perhaps trying to run STA with 4addr bridging? If so then make sure
> you use recent ath10k as this was known to be a problem.
> 
We tested without the 4addr bridging, that works fine but we can't add the interface in bridge :-(

Have you a benchmark reference with ATH10K ? at this time we can send around 700 Mbit/s, is it the maximum or we can expected better ?
> 
> Michał

Thanks

Cedric Voncken

