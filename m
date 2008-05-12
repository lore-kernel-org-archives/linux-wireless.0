Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:21926 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYELRjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 13:39:22 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3593153waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 10:39:22 -0700 (PDT)
Message-ID: <1ba2fa240805121039u1fc4273eh706c8868748b500c@mail.gmail.com> (sfid-20080512_193927_087703_45CB31FF)
Date: Mon, 12 May 2008 20:39:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: New GIT net tree naming...
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>, sfr@canb.auug.org.au,
	akpm@linux-foundation.org, netdev@vger.kernel.org
In-Reply-To: <20080508144046.GA3515@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080419.173510.257216556.davem@davemloft.net>
	 <20080508014358.GE3412@tuxdriver.com>
	 <200805080906.29603.hs4233@mail.mn-solutions.de>
	 <20080508144046.GA3515@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 8, 2008 at 5:40 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, May 08, 2008 at 09:06:29AM +0200, Holger Schurig wrote:
>> > For changes against Linus's current tree:
>> ...
>> > For development meant to be merged in the next merge
>> > window we have:
>>
>> Is this relevant for us, the patch submitters?  Or should we
>> continue to create patches against wireless-testing?
>
> Please continue to use wireless-testing.
>
> Thanks!
>
John
How would you want me to handle bug fixes to go both directions
wireless-testing and upstream?
Because of huge code movement we are now doing in iwlwifi they are
currently just not the same.
Shell I send two versions or you want to back port them not sure how
do you want to track this...somewhere in merging loop it will create a
conflict.  Maybe this is maintainer trivia anyhow
I would like to make sure there are not glitches.

Thanks
Tomas

Thanks
Tomas

> JOhn
> --
> John W. Linville
> linville@tuxdriver.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
