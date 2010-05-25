Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40211 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0EYNpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 09:45:13 -0400
Date: Tue, 25 May 2010 09:38:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: A band is missing for IL
Message-ID: <20100525133823.GC31753@tuxdriver.com>
References: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 25, 2010 at 10:03:05AM +0300, Emmanuel Grumbach wrote:
> According to http://en.wikipedia.org/wiki/List_of_WLAN_channels#5.C2.A0GHz_.28802.11a.2Fh.2Fj.2Fn.29
> 
> Channels 34 - 64 are allowed in 20 Mhz in Israel. This is not what is
> written in db.txt:
> 
> country IL:
>          (2402 - 2482 @ 40), (N/A, 20)
> 
> This wikipedia page relies on an official page from the Israel
> Ministry of the Communication.

Would you care to send a patch?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
