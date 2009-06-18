Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40212 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbZFRMdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 08:33:43 -0400
Received: by bwz9 with SMTP id 9so1022422bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 05:33:45 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ramesh R <rramesh_1@yahoo.com>, linux-wireless@vger.kernel.org
Subject: Re: Power save / 11v support feature
References: <933839.92475.qm@web54506.mail.re2.yahoo.com>
	<1245257582.31588.34.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 18 Jun 2009 15:33:42 +0300
In-Reply-To: <1245257582.31588.34.camel@johannes.local> (Johannes Berg's message of "Wed\, 17 Jun 2009 18\:53\:02 +0200")
Message-ID: <877hz990wp.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-06-17 at 09:09 -0700, Ramesh R wrote:
>> Hello,
>> 
>> I am interested to work on the power save /  11v support. Is someone already working on this?
>
> In what sense would you want to work on it? I mean, on what in
> particular? 11v support probably needs firmware support first so unless
> you have a device you can hack for that you're not going to be able to
> do much ... ar9170 comes to mind, but doesn't really have powersaving
> anyway.
>
> And just general powersaving, what actually remains to be done? Could
> look into supporting uAPSD on station side, I guess?

Yes, at least client mode U-APSD is needed. And I'm sure there's room
for improvements.

-- 
Kalle Valo
