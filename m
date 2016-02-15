Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbcBOPnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 10:43:22 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] staging: rtl8723au: whitespace and blank line cleaning
References: <eab3a03d1254ca4e8089a72fdd31620b35d8f46f.1454815347.git.geliangtang@163.com>
	<74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
	<2c43b083b87c55fd061f453e8e9c4caaf87c66b7.1454815347.git.geliangtang@163.com>
	<CAGRGNgXDQXPOydOh_TFmJX=0sMVtwkb_XpOJx3CrjXfRopYJ4Q@mail.gmail.com>
Date: Mon, 15 Feb 2016 10:43:21 -0500
In-Reply-To: <CAGRGNgXDQXPOydOh_TFmJX=0sMVtwkb_XpOJx3CrjXfRopYJ4Q@mail.gmail.com>
	(Julian Calaby's message of "Mon, 8 Feb 2016 09:17:22 +1100")
Message-ID: <wrfjoabivv1i.fsf@redhat.com> (sfid-20160215_184439_212056_CCE4F004)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Geliang,
>
> On Sun, Feb 7, 2016 at 2:30 PM, Geliang Tang <geliangtang@163.com> wrote:
>> This patch cleans whitespaces and blank lines surrounding
>> list_for_each_entry*().
>
> It does a lot more than this, including:
>  - Removing some unnecessary brackets
>  - Whitespace changes well away from the list_for_each_entry*() calls
>
> You need to either specify all of these in the changelog or split it
> up into multiple patches.
>
> Thanks,
>
> Julian Calaby

I agree, I think a more descriptive patch message will suffice here.

Jes
