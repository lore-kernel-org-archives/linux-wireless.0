Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:54939 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYAYEsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 23:48:00 -0500
Received: by an-out-0708.google.com with SMTP id d31so120742and.103
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2008 20:47:59 -0800 (PST)
Message-ID: <40f31dec0801242047u326772b4t66078a0edb052d2a@mail.gmail.com> (sfid-20080125_044805_250656_431405A9)
Date: Fri, 25 Jan 2008 06:47:59 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "hong zhang" <henryzhang62@yahoo.com>
Subject: Re: does any wifi driver supports 802.11n for access point?
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <146972.90137.qm@web57911.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1201226946.15917.12.camel@localhost.localdomain>
	 <146972.90137.qm@web57911.mail.re3.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 3. Does mac80211 run on atheros chip for access point?
> It seems that mac80211 package only supports station.
>

Not yet, we 're working on fixing several issues right now.

As for Atheros's 802.11n parts, we still have lot of work to do, even
madwifi/binary HAL doesn't support n right now.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
