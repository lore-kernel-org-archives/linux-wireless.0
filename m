Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36691 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbD0GWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 02:22:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Nuno =?utf-8?Q?Gon=C3=A7al?= =?utf-8?Q?ves?=
	<nunojpg@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Ubuntu regulatory database
References: <CAEXMXLSucPD3x6igB6pLs=8cBmc-oY0Ah+nLA3kVfS1y6kLhLQ@mail.gmail.com>
	<20150425190912.GA1706@ubuntu-xps13>
	<87y4leqhu6.fsf@kamboji.qca.qualcomm.com>
	<1430112118.12579.2.camel@coelho.fi>
Date: Mon, 27 Apr 2015 09:22:07 +0300
In-Reply-To: <1430112118.12579.2.camel@coelho.fi> (Luca Coelho's message of
	"Mon, 27 Apr 2015 08:21:58 +0300")
Message-ID: <87tww2qeeo.fsf@kamboji.qca.qualcomm.com> (sfid-20150427_082225_313905_5D68C0FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

>> > But yes, it recently came to my attention that our distro package hadn't
>> > been updated in a while (I don't maintain the distro package and
>> > obviously wasn't paying close enough attention). It will be updated
>> > soon.
>> 
>> Oh, so does this mean that the old regdb doesn't support 80 MHz
>> channels?
>
> Yeah, we had a bug reported from the community that turned out to be
> about this:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=95901

Hehe, this was exactly what I was worried about :)

-- 
Kalle Valo
