Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40364 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab0LEPb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 10:31:27 -0500
Message-ID: <4CFBB049.6050106@hauke-m.de>
Date: Sun, 05 Dec 2010 16:31:21 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless release for 2010-12-04 is baked
References: <20101204200249.298B040F97@repository3.orbit-lab.org> <1291562545.3495.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291562545.3495.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2010 04:22 PM, Johannes Berg wrote:
> On Sat, 2010-12-04 at 15:02 -0500, Compat-wireless cronjob account
> wrote:
> 
>> scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile: No such file or directory
>> make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile'.  Stop.
>> make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap] Error 2
>> make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
>> make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
>> make: *** [clean] Error 2
> 
> maybe the script can at least change the subject to "half-baked" when it
> fails ;-)
> 
> johannes

This build was ok, the error occurred while doing make clean on the old
build from 2010-12-03. That image was not generated successfully and so
make clean fails.

Hauke
