Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34474 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaKKScE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 13:32:04 -0500
Received: by mail-wi0-f179.google.com with SMTP id h11so2514142wiw.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 10:32:03 -0800 (PST)
From: Uwe Brauer <oub@mat.ucm.es>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw\@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: Thinkpad X60s/200s: Intel 3945/5100 works with kernel 2.6.32-67/3.0.0-32 but not 3.7 vanilla.
References: <87d28zdplq.fsf@mat.ucm.es>
	<CANUX_P0f0WAHoq3CsC3V-jp4m3_Q7qLz7X+Mvn1hk9_JPrPTGg@mail.gmail.com>
	<87egtbxs8t.fsf@mat.ucm.es> <1415615960.1847.11.camel@sipsolutions.net>
Reply-To: Uwe Brauer <oub@mat.ucm.es>
Date: Tue, 11 Nov 2014 19:31:51 +0100
Message-ID: <8761ellhbc.fsf@mat.ucm.es> (sfid-20141111_193211_357850_3C59EEF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


   > On Mon, 2014-11-10 at 11:30 +0100, Uwe Brauer wrote:

   > You'd need CONFIG_CFG80211_WEXT (or so) as well, but realistically you

Thanks indeed that solved the problem. So I can use ubuntu
10.04+jfs+trim+wireless great!

   > should stop using wireless extensions and use nl80211 (via the "iw"
   > tool) instead.

Thanks but I am not sure whether it will work in Ubuntu 10.04 I am
currently using.

Uwe 

