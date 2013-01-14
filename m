Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46732 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3ANNid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 08:38:33 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Eugene <wifi.mailing.list@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Custom commands for cfg80211 based driver (like iwpriv)
References: <CAMvjH0A69ZBCZc5qjm_cUYj3bDzSmneaz1u9CsPcJEm2T0Q1iw@mail.gmail.com>
	<87txqkz0yk.fsf@purkki.adurom.net>
	<CAMvjH0BkRS0HpjqHQyFOmnqmQs4AR9HGWh07FSz2yh3TiTBy6w@mail.gmail.com>
	<CAGRGNgXBNSRTK+zjaxg5eD-zDv6OE_S_iU7Gb3v5W=M_92qdrg@mail.gmail.com>
Date: Mon, 14 Jan 2013 15:38:32 +0200
In-Reply-To: <CAGRGNgXBNSRTK+zjaxg5eD-zDv6OE_S_iU7Gb3v5W=M_92qdrg@mail.gmail.com>
	(Julian Calaby's message of "Mon, 14 Jan 2013 23:12:36 +1100")
Message-ID: <87hamjzxyf.fsf@purkki.adurom.net> (sfid-20130114_143837_405745_8D0EF106)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

>> Why kernel do not support custom commands, like TESTMODE?
>
> The goal, as I understand it, is to work out a framework for how
> TESTMODE could be implemented in a unified manner across all the
> drivers for all hardware which supports it. I'm not sure that any real
> progress has been made.

I personally think that will never work out. With testmode we are
talking about very low level features like RF registers, calibration, HW
testing etc. Stuff which is only run in a factory or by an RF engineer.
Finding a common interface for all HW designs is hard as they are so
different.

(Disclaimer: of course the above doesn't apply to high level features
related 802.11 and both cfg80211 and mac80211 are a great proof of that)

-- 
Kalle Valo
