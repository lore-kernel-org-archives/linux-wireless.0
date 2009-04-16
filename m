Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:57239 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZDPAvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:51:55 -0400
Received: by mu-out-0910.google.com with SMTP id g7so63044muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 17:51:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239841547.25334.19.camel@johannes.local>
References: <20090416002449.GB4138@makis>
	 <1239841547.25334.19.camel@johannes.local>
Date: Thu, 16 Apr 2009 03:51:54 +0300
Message-ID: <40f31dec0904151751u3fd15d93i194d0abbb4657439@mail.gmail.com> (sfid-20090416_025159_993866_BBFDB05C)
Subject: Re: [PATCH 2/7] ath5k: Read Spur channels from EEPROM
From: Nick Kossifidis <mickflemm@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/16 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2009-04-16 at 03:24 +0300, Nick Kossifidis wrote:
>> *Read Spur channel information from EEPROM and use default channels for RF5413 compatible chips that don't have this info on EEPROM.
>
> I think you should break the changelog at fewer columns than that.
>
> johannes
>

ACK, are 80 cols ok ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
