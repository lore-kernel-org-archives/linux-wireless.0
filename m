Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:32839 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZJZVPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 17:15:11 -0400
Received: by ey-out-2122.google.com with SMTP id 9so2482132eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 14:15:15 -0700 (PDT)
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH v2 2/4] ath9k_hw: distinguish single-chip solutions on initial probe print
References: <1256575447-4591-1-git-send-email-lrodriguez@atheros.com>
	<87d449hp73.fsf@purkki.valot.fi> <20091026204447.GA5713@tux>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 26 Oct 2009 23:15:13 +0200
In-Reply-To: <20091026204447.GA5713@tux> (Luis R. Rodriguez's message of "Mon\, 26 Oct 2009 13\:44\:47 -0700")
Message-ID: <878wexhn6m.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@Atheros.com> writes:

>> I think you should provide the size of hw_name to this function and
>> use snprintf() to avoid writing out of bounds.
>
> I was going to do this but since I know the users of it and control
> it seemed to not matter. I'll respin with this added, better to be careful.

Yeah, you never know if someone (for example a crazy Finn just after a
refreshing sauna) comes along, changes the function a bit "to clean it
up" and creates a subtle bug ;)

-- 
Kalle Valo
