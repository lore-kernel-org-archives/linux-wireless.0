Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:58979 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbYEIOKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 10:10:24 -0400
Date: Fri, 9 May 2008 16:10:23 +0200 (CEST)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: Dan Williams <dcbw@redhat.com>
cc: David Woodhouse <David@Woodhou.se>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, John Daiker <daikerjohn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	julian.calaby@gmail.com, andreamrl@tiscali.it
Subject: Re: Update: [RFC][PATCH] mrv8k: Driver for "Marvell 88w8335 [Libertas]"
In-Reply-To: <1210268717.24803.9.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0805091604230.24384@bugs.comnets.uni-bremen.de> (sfid-20080509_160920_144188_A88FF1DB)
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
 <1209057680.9212.1065.camel@pmac.infradead.org>  <4821F389.6070905@gmail.com>
  <200805080912.49903.hs4233@mail.mn-solutions.de>
 <Pine.LNX.4.64.0805081022470.24384@bugs.comnets.uni-bremen.de>
 <1210257822.24803.0.camel@localhost.localdomain>  <1210258953.25560.1112.camel@pmac.infradead.org>
 <1210268717.24803.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have just pushed the mrv8k patch sent to the mailing list to 
git://git.infradead.org/mrv8k-2.6.git.

Markus

On Thu, 8 May 2008, Dan Williams wrote:

> On Thu, 2008-05-08 at 16:02 +0100, David Woodhouse wrote:
>> On Thu, 2008-05-08 at 10:43 -0400, Dan Williams wrote:
>>> Yeah, I'll get David to make a git tree.  You should still ask for an
>>> account and send him your SSH key so that you can push to the tree as
>>> well.
>>
>> I've created git://git.infradead.org/mrv8k.git and the mrv8k group,
>> which has schurig,mab,dwmw2,dcbw in it.
>>
>> I'm a little confused by the request, because I thought wireless
>> development was stuck in the 1990s and didn't use git -- I thought it
>> was done by patches. But I'll let you work that one out for
>> yourselves. :)
>
> We've got a ways to go before we can upstream the driver.  There's still
> quite a bit of cleanup to do.  Best to do that with a git tree first
> before submitting the cleaned up patch set.
>
> Dan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
