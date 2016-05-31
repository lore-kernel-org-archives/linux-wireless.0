Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:50565 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbcEaMMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 08:12:20 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, johannes@sipsolutions.net,
	apenwarr@gmail.com
Subject: Re: [Make-wifi-fast] [PATCHv5 0/5] mac80211: implement fq_codel
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	<1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 31 May 2016 14:12:15 +0200
In-Reply-To: <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 19 May 2016 10:37:47 +0200")
Message-ID: <87zir6ctpc.fsf@toke.dk> (sfid-20160531_141223_297227_6A6CE414)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patchset disables qdiscs for drivers
> using software queuing and performs fq_codel-like
> dequeuing on txqs.

Hi Michal

Is this version in a git repo somewhere I can pull from? :)

-Toke
