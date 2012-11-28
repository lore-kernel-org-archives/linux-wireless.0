Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.legal.de ([46.38.240.131]:60289 "EHLO mail.legal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab2K1PV0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 10:21:26 -0500
Message-ID: <50B62BEB.6020109@schwarze-allianz.de> (sfid-20121128_162131_467038_243B4005)
Date: Wed, 28 Nov 2012 16:21:15 +0100
From: Jens Kapitza <j.kapitza@schwarze-allianz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi hibernate / suspend issue
References: <50B61C71.6060007@schwarze-allianz.de> (sfid-20121128_152227_935873_AFE02FFF) <1354113010.9345.27.camel@jlt4.sipsolutions.net> <50B62254.9070700@schwarze-allianz.de> <1354113722.9345.28.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354113722.9345.28.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> just enter "dmesg" and pastebin the result somewhere
>
> johannes
>
this line seems to be wrong

  [ 4650.687346] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.


working iwlwifi dmesg

http://pastebin.com/S9GwEMpg


after suspend

http://pastebin.com/ZB1BLwkc

jens
