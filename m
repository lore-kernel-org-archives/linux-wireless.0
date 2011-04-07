Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54266 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1DGVrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 17:47:17 -0400
Message-ID: <4D9E30DE.5060500@hauke-m.de>
Date: Thu, 07 Apr 2011 23:47:10 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Compat-wireless release for 2011-04-07 is baked
References: <776804.71360.qm@web161620.mail.bf1.yahoo.com>
In-Reply-To: <776804.71360.qm@web161620.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2011 10:47 PM, Walter Goldens wrote:
> --- On Thu, 4/7/11, Compat-wireless cronjob account <compat@orbit-lab.org> wrote:
> 
>> From: Compat-wireless cronjob account <compat@orbit-lab.org>
>> Subject: Compat-wireless release for 2011-04-07 is baked
> 
> Luis, I've been meaning to ask you. Every now and then the CW mails claim that a new compat-wireless is released, but often is the case where it's not actually uploaded. Neither in kernel.org nor orbit-lab.
> Do you manually upload them and is it possible to automate to uploading procedure as well?
> 
> 
> Walter
Hi Walter,

the subject of this message is wrong, compat-wireless release for
2011-04-07 was not baked, because some patches do not apply. ;-)
A successful message should look like this:
http://www.spinics.net/lists/linux-wireless/msg66930.html
When the statistic is included it was successful.

compat-wireless is build automatically by a daily cron job and this cron
job also sends these mails.

You could apply the patches I send to the mailing list some hours ago
and generate your own compat-wireless version or wait some time.

Hauke
