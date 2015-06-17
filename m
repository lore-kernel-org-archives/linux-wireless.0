Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36770 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbbFQUcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 16:32:54 -0400
Received: by igbiq7 with SMTP id iq7so76461940igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 13:32:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1434568011.1884.42.camel@sipsolutions.net>
References: <5581BEBA.1080500@broadcom.com>
	<1434568011.1884.42.camel@sipsolutions.net>
Date: Wed, 17 Jun 2015 22:32:53 +0200
Message-ID: <CACna6rwq6VB+mg2tLetmMQTA0xexbDwi=JdoBgHRxDB4EgeUeA@mail.gmail.com> (sfid-20150617_223259_245269_557A779D)
Subject: Re: creating ap interface
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 June 2015 at 21:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-06-17 at 20:38 +0200, Arend van Spriel wrote:
>> Hi Dan,
>>
>> When I create an AP interface using iw, it is followed by a change
>> interface back to managed mode. I added a WARN_ON to see where it came
>> from and it turns out to be the NetworkManager. However, I had disabled
>> wifi as you suggested on the mailing list once. What is your take on
>> this: bug or intentional?
>
> You shouldn't really have a WARN_ON() on a path that can be hit by
> userspace like that :)

I'm pretty sure it was for debugging purposes.
