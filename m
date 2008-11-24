Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:2059 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYKXX0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 18:26:44 -0500
Received: by yw-out-2324.google.com with SMTP id 9so964234ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 15:26:43 -0800 (PST)
Message-ID: <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com> (sfid-20081125_002647_989818_9C212585)
Date: Mon, 24 Nov 2008 15:26:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: wireless-regdb: flaw in general functionality
Cc: "Richard Farina" <sidhayn@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1227568883.28878.15.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla>
	 <1227568883.28878.15.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 3:21 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2008-11-24 at 15:12 -0800, Luis R. Rodriguez wrote:
>
>> Your point about not being able to listen is a good one, and a patch to
>> update the the US in consideration of part 15 rules would be
>> appreciated. Keep in mind we have flags for such things:
>>
>>   -Passive scan
>>   -No-IBSS
>>
>> We should probably rename no-ibss to no-beaconing though as that is the
>> real meaning inention behind it.
>
> Maybe you mean no-transmit?

Yeah sure, that seems to make more sense.

 Luis
