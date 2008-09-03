Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34496 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYICPZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 11:25:15 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb.[ch] gone fishing from wireless-testing ?
References: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com>
	<87vdxedje8.fsf@nokia.com>
	<43e72e890809022003gfd462d2ma8d68f032754c121@mail.gmail.com>
	<20080903125352.GI3050@tuxdriver.com> <87zlmpuwmc.fsf@nokia.com>
	<20080903145007.GL3050@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 03 Sep 2008 18:25:09 +0300
In-Reply-To: <20080903145007.GL3050@tuxdriver.com> (John W. Linville's message of "Wed\, 3 Sep 2008 10\:50\:07 -0400")
Message-ID: <8763pdfe0a.fsf@litku.valot.fi> (sfid-20080903_172519_955340_6F3A66A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville <linville@tuxdriver.com> writes:

> On Wed, Sep 03, 2008 at 05:34:03PM +0300, Kalle Valo wrote:
>> John W. Linville <linville@tuxdriver.com> writes:
>> 
>> > Anyone want to talk me out of pulling-in the at76 parts?
>> 
>> Sorry, I don't quite understand what pulling-in means here.
>
> I just mean making sure it is (and continues to be) in
> wireless-testing's master branch.

Ok, thanks for the explanation.

>> But personally I don't mind, choose which one is best in your opinion.
>> If you drop it, I can always resubmit it when it's properly working.
>
> Leaving it in has encouraged people to keep it up-to-date (or at least
> compiling) across mac80211 driver API changes.  Whether or not this
> has been worthwhile is, of course, debatable.

>From my perspective it has been worthwhile, but at the same time I
realise how much work it means for you. And as I know how busy you are
I really would not want to cause you any extra work.

> P.S.  For the record, I _would_ like to see a working at76 driver
> make it upstream at some point.

Me too. Fortunately starting from September I will have some free time
(yay!) and I can start working with at76 again.

-- 
Kalle Valo
