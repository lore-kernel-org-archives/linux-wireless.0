Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43866 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZBBXOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 18:14:00 -0500
Received: by ewy14 with SMTP id 14so2152339ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 15:13:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0902021333x2880b7dfj279822622a3d5cc3@mail.gmail.com>
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
	 <e27b78a40901260625w53acd646xeb5a9ca85555c74d@mail.gmail.com>
	 <e27b78a40901260956w4e69d33s7db60defc026c8d7@mail.gmail.com>
	 <45e8e6c40901280954l42bbe788y8723141d673bb7b3@mail.gmail.com>
	 <e27b78a40901300446y294504d5kd7acaa6c5a26edd@mail.gmail.com>
	 <e27b78a40901300601p35d68125kfc3a10a7d7db0900@mail.gmail.com>
	 <7c8826910901301109s6d80a75ale251ec837eabccf0@mail.gmail.com>
	 <e27b78a40902021013v272ec315nece744d3cf1dc75c@mail.gmail.com>
	 <7c8826910902021255g2563400an24f97014abf854f8@mail.gmail.com>
	 <b6c5339f0902021333x2880b7dfj279822622a3d5cc3@mail.gmail.com>
Date: Mon, 2 Feb 2009 15:13:58 -0800
Message-ID: <7c8826910902021513o5719927ej12c860d55b49101c@mail.gmail.com> (sfid-20090203_001409_488889_1CE4DB14)
Subject: Re: Crashing on ping?
From: Mike Cui <cuicui@gmail.com>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Keir <keirlawson@gmail.com>, Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No I don't have stack trace. The system completely freezes, to a point
where even the magic sysreq key doesn't respond. I can try this patch.
what does it fix, exactly?

On Mon, Feb 2, 2009 at 1:33 PM, Bob Copeland <bcopeland@gmail.com> wrote:
> On Mon, Feb 2, 2009 at 3:55 PM, Mike Cui <cuicui@gmail.com> wrote:
>> No. crash happens when I use it in regular access point mode.
>>
>
> Do you have a stack trace?  And does this patch help?
>
> http://bugzilla.kernel.org/attachment.cgi?id=19985
> --
> Bob Copeland %% www.bobcopeland.com
>
