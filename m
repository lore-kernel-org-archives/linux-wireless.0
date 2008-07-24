Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:59134 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYGXVfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:35:08 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1318573ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 14:35:07 -0700 (PDT)
Message-ID: <40f31dec0807241435x2e9f6ae1x1d136c1b0d20c874@mail.gmail.com> (sfid-20080724_233511_725958_2C0A4B04)
Date: Fri, 25 Jul 2008 00:35:06 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH 1/12] ath5k: Update register list
Cc: "Nick Kossifidis" <mick@madwifi.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <1216934605.3094.5.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720033041.GA7440@makis> <1216934605.3094.5.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> -                     ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
>> +                     ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
>
> You are replacing macros with numbers in several places.  Maybe you
> could introduce another macro?  Or is it the case when you had
> interpretation of the registers, but now realize that it was wrong?
>

Helps me with rev. engineering, i'll hopefully introduce a macro for
these registers soon...



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
