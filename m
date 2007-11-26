Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:55363 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbXKZOuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:50:01 -0500
Received: by py-out-1112.google.com with SMTP id u77so1369921pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 06:50:00 -0800 (PST)
Message-ID: <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com> (sfid-20071126_145007_916809_40607F9F)
Date: Mon, 26 Nov 2007 15:50:00 +0100
From: dragoran <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>, "Jouni Malinen" <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <474955E1.30603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

btw would it make sense to ratelimit

"WEP decrypt failed (ICV)" messages?
they are a bit annoying when connected to this network...

dmesg  | grep ICV | wc -l
3489

after some minutes.
