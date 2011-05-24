Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39339 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1EXP6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 11:58:48 -0400
Received: by gyd10 with SMTP id 10so2615836gyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 08:58:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306252192.3839.1.camel@jlt3.sipsolutions.net>
References: <1305917869.4640.15.camel@jlt3.sipsolutions.net>
	<1305917949.4640.16.camel@jlt3.sipsolutions.net>
	<BANLkTikjDhdYMssyivgRxAyB5-_FctQbSg@mail.gmail.com>
	<2eafee5b7a180c891df4a9ca53e90d7d@secure.sipsolutions.net>
	<BANLkTim+boto9xStdaAyWeTR1+Fw=ADjwA@mail.gmail.com>
	<1306252192.3839.1.camel@jlt3.sipsolutions.net>
Date: Tue, 24 May 2011 18:58:47 +0300
Message-ID: <BANLkTimpyZPJPVnFR_UrPwppHyx_S4fjeg@mail.gmail.com> (sfid-20110524_175851_650816_A32CD48B)
Subject: Re: netlink reverts
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Javier Cardona <javier@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 24, 2011 at 6:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2011-05-21 at 08:40 -0700, Javier Cardona wrote:
>
>> It's ok to move the plink_state attribute.  There are only a handful
>> of users of the secured mesh at this point.
>
> Let's stick to what we have and all copy a new nl80211.h from the
> current tree, I had this in iw but nobody could really be using it since
> no driver has wowlan.
>
that's not entirely true, but i don't care moving to the new nl80211.h ;)
