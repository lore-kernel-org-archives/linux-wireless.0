Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:32876 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbZAORy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 12:54:59 -0500
Received: by rn-out-0910.google.com with SMTP id k40so981503rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 09:54:58 -0800 (PST)
Message-ID: <43e72e890901150954t4bc9a390x43a30f287b609173@mail.gmail.com> (sfid-20090115_185505_441767_793C6B31)
Date: Thu, 15 Jan 2009 09:54:57 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless-regdb updated 2009-01-15 (was Re: wireless-regdb updated 2009-01-14)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Helmut Schaa" <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1232031893.5839.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20090114162250.GC3854@tuxdriver.com>
	 <200901151011.23147.helmut.schaa@gmail.com>
	 <20090115134928.GA3241@tuxdriver.com>
	 <1232031893.5839.0.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 15, 2009 at 7:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-01-15 at 08:49 -0500, John W. Linville wrote:
>
>> > Do you plan to push a new tarball to [1]?
>
>> > [1] http://wireless.kernel.org/download/wireless-regdb/
>>
>> Probably a good idea, but I didn't put that one there.  I think that is Luis IIRC...?
>
> I thought it was updated nightly?

It is -- seems it hadn't run yet, scheduled to run at 06:10 CET (its
now 18:51 CET), I manually ran it, but also changed it to not have
"master" prefix in the tarball releases.

http://wireless.kernel.org/download/wireless-regdb/

Additionally for those distributions packaging based on John's
regulatory.bin I've put a regulatory.bins dir with just the
regulatory.bin files in it. You will also find a
latest-regulatory-info.txt which tells you the latest regulatory.bin
file used and its SHA1 sum. latest-regulatory.bin is a symlink to this
file. I'll set CRDA to pull this latest file upon building too by
default.

  Luis
