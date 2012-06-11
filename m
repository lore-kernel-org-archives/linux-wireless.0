Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2FKGss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 02:48:48 -0400
Message-ID: <1339397324.4520.0.camel@jlt3.sipsolutions.net> (sfid-20120611_084851_416573_09D9F6CF)
Subject: Re: Connected standby support ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, users@rt2x00.serialmonkey.com,
	joeyli <jlee@suse.com>, Michael Chang <mchang@suse.com>
Date: Mon, 11 Jun 2012 08:48:44 +0200
In-Reply-To: <CALx5=V9GPe0ad2=im4bvS0AMdXVQ7TF-dkW_dgUG1H1S1ek=3A@mail.gmail.com>
References: <CALx5=V8gS-FudA0EAmoEs=xwQ7hr_BntO4Jr_+6tR9pYSNDUdg@mail.gmail.com>
	 <1338894402.4514.28.camel@jlt3.sipsolutions.net>
	 <CALx5=V9GPe0ad2=im4bvS0AMdXVQ7TF-dkW_dgUG1H1S1ek=3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 12:02 +0800, Matt Chen wrote:
> Hi Johannes,
> 
> What is wowlan ? Does it need BIOS suuport ?

http://wireless.kernel.org/en/users/Documentation/WoWLAN

It needs platform support to leave the card powered on.

johannes

