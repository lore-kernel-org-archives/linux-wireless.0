Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55513 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3AHR2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 12:28:45 -0500
Received: by mail-wg0-f47.google.com with SMTP id dq11so528483wgb.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2013 09:28:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130108141328.GA18920@pandem0nium>
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CAJ-Vmok_UDVykup4xHCigrBbzErOhUQOZMATJ+=qkBFOHQS+Bg@mail.gmail.com>
	<1357131499.9839.19.camel@jlt4.sipsolutions.net>
	<201301021436.55010.chunkeey@googlemail.com>
	<1357137688.9839.43.camel@jlt4.sipsolutions.net>
	<20130108141328.GA18920@pandem0nium>
Date: Tue, 8 Jan 2013 09:28:44 -0800
Message-ID: <CAJ-Vmom91BS5fPas+FWsaqQwm-ZVcZckUXB2vQgoEXtKiOH6mA@mail.gmail.com> (sfid-20130108_182849_414931_18E77AC8)
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I still populate the WME fields; I need to "fix" paying attention to
them in the adhoc case.

The performance loss without them is quite noticable.



Adrian
