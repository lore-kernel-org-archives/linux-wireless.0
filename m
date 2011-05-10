Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42911 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1EJPFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 11:05:22 -0400
Message-ID: <4DC9542C.6060508@hauke-m.de> (sfid-20110510_170526_295251_895A8EBA)
Date: Tue, 10 May 2011 17:05:16 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/3] compat-wireless: enable RT33XX and RT53XX support.
References: <684215.94213.qm@web161615.mail.bf1.yahoo.com>
In-Reply-To: <684215.94213.qm@web161615.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 04:44 PM, Walter Goldens wrote:
> 
>> This is based on a patch by Walter
>> Goldens.
> 
> Hi Hauke,
> 
> I think RT53XX is still experimental, unlike the RT33XX. Should we enable it from config.mk now?
> 
> Walter

Hi Walter,

In the description of RT53XX there is no warning that this is not
working, like it is in the description of RT35XX. I do not have such a
device, but the rt2x00 guys could probably help on this questing. If we
enable it and it does not work it will not hurt people more that we do
not activate it.

@rt2x00 people: Are the RT53XX chips working with the most recent
version of the rt2x00 driver from wireless-testing?

Hauke
