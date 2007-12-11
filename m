Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45938 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXLKVVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 16:21:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "mohamed salim abbas" <mabbaswireless@gmail.com>
Subject: Re: [PATCH 2/4] iwlwifi: Update to changed mac80211 rate control interface
Date: Tue, 11 Dec 2007 22:19:08 +0100
Cc: "Stefano Brivio" <stefano.brivio@polimi.it>,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <1197112439.7472.34.camel@localhost> <20071208141953.1233aa30@morte> <b3153e950712111310r7f527068j7997bdceaee3488@mail.gmail.com>
In-Reply-To: <b3153e950712111310r7f527068j7997bdceaee3488@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712112219.09079.mb@bu3sch.de> (sfid-20071211_212108_561425_B88F6364)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 December 2007 22:10:38 mohamed salim abbas wrote:
> for any non data frame we should use the lowest rate. the firmware
> might not like it if higher rate been used.

Why not fix the firmware?

-- 
Greetings Michael.
