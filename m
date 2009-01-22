Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:40948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZAVObG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 09:31:06 -0500
Received: by ug-out-1314.google.com with SMTP id 39so500921ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 06:31:05 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bharat Bhushan <bharat.b.bhushan@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: porting open source mac to linux 2.6.13.0
References: <d9360e520901212124j7bf196c3sf4e29d8fd3650f9b@mail.gmail.com>
	<1232621606.30174.16.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 22 Jan 2009 16:31:02 +0200
In-Reply-To: <1232621606.30174.16.camel@johannes.local> (Johannes Berg's message of "Thu\, 22 Jan 2009 11\:53\:26 +0100")
Message-ID: <87eiyvl8ex.fsf@litku.valot.fi> (sfid-20090122_153110_232715_4F6BF97E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-01-22 at 10:54 +0530, Bharat Bhushan wrote:
>> hi all,
>>          Is there any possible way to port open source mac stck on
>> linux kernel 2.6.13.0 . Problem is, i am using a embedded platform
>> which is supporting only 2.6.13. 0 and now assigned job is to make it
>> working for open source mac stack without porting any other changes of
>> linux kernel .
>
> First, read Holgers mail. Then re-read it.

Yes, Holger's mail was to the point.

> Then cancel the contract with your embedded vendor and find a decent
> one.

Just out of curiousity, is there an embedded vendor who adds support
to the mainline kernels and maintains it? To me it looks like more or
less everyone want to fork their own kernel and then forget it.

-- 
Kalle Valo
