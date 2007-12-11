Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:47825 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752178AbXLKVzs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 16:55:48 -0500
Date: Tue, 11 Dec 2007 22:48:38 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "mohamed salim abbas" <mabbaswireless@gmail.com>
Cc: "Mattias Nissler" <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/4] iwlwifi: Update to changed mac80211 rate control
 interface
Message-ID: <20071211224838.6f0c5214@morte> (sfid-20071211_215551_031392_55C29DD4)
In-Reply-To: <b3153e950712111310r7f527068j7997bdceaee3488@mail.gmail.com>
References: <1197112439.7472.34.camel@localhost>
	<1197112911.7472.50.camel@localhost>
	<20071208141953.1233aa30@morte>
	<b3153e950712111310r7f527068j7997bdceaee3488@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Dec 2007 13:10:38 -0800
"mohamed salim abbas" <mabbaswireless@gmail.com> wrote:

> for any non data frame we should use the lowest rate. the firmware
> might not like it if higher rate been used. I just checked out latest
> of mac80211 the rate scaling functions have not changed with this
> patch it wont work.

Please:
1) don't do top-posting;
2) reply to the appropriate message.


-- 
Ciao
Stefano
