Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33626 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbCJPf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:35:56 -0400
Received: by iecvj10 with SMTP id vj10so19306879iec.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 08:35:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87385dz2yx.fsf@kamboji.qca.qualcomm.com>
References: <1425929918-860-1-git-send-email-linux@rempel-privat.de>
	<87385dz2yx.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 10 Mar 2015 08:35:55 -0700
Message-ID: <CAJ-Vmon6j71Eurbe7Sg2ZB06hbOymVYSge_-LeUKCXRDmLE5mw@mail.gmail.com> (sfid-20150310_163601_278152_2EE43620)
Subject: Re: [PATCH] ath9k_htc: force FW v1.4.0
From: Adrian Chadd <adrian@freebsd.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeah, let's have it warn for a month or two.

There's some pending work that will break the API with 1.3 firmware,
so it has to happen sooner rather than later. But yeah, maybe warn for
about a month would be good. the older firmware is still in the git
tree in case people want it.


-adrian
