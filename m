Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:19719 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYJDNHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 09:07:10 -0400
Received: by qw-out-2122.google.com with SMTP id 3so451015qwe.37
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 06:07:08 -0700 (PDT)
Message-ID: <69e28c910810040607x392a5ddfra8d257b0ff3b9c6e@mail.gmail.com> (sfid-20081004_150721_756107_24FBF6B6)
Date: Sat, 4 Oct 2008 15:07:08 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: Trendnet TEW-424UB now Realtek 8187B
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, keithl@keithl.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
In-Reply-To: <1223110250.24551.72.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081004011510.GA10015@gate.kl-ic.com>
	 <1223109126.24551.70.camel@johannes.berg>
	 <43e72e890810040147j6f15966awbe555b6d37135960@mail.gmail.com>
	 <1223110250.24551.72.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 4, 2008 at 10:50 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-10-04 at 01:47 -0700, Luis R. Rodriguez wrote:
>> On Sat, Oct 4, 2008 at 1:32 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Fri, 2008-10-03 at 18:15 -0700, Keith Lofstrom wrote:
>> What Realtek driver? Just FYI rtl8187 does *not* claim the RTL8187B. See:
>>
>> http://wireless.kernel.org/en/users/Drivers/rtl8187
>
> Oh, I thought there was a version now that did.
>
> johannes
>

Hin-Tak Leung added support for RTL8187B a while ago, although it's
still a bit buggy. Likely someone forgot to update the rtl8187 page on
the wiki. CCing Hin-Tak and Herton.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
