Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:43651 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaH1U6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 16:58:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140828120851.07dbd1c52ec287ca169acee4@linux-foundation.org>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20140828183330.GM13758@tuxdriver.com>
	<20140828120851.07dbd1c52ec287ca169acee4@linux-foundation.org>
Date: Thu, 28 Aug 2014 23:58:45 +0300
Message-ID: <CAHp75Vdi6jaexNOFV0mLn=sFOSqmLPNKoGwniSnE0oMim0hjTA@mail.gmail.com> (sfid-20140828_225903_433442_A03478EB)
Subject: Re: [PATCH v3 00/11] lib: introduce string_escape_mem and %*pE specifier
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2014 at 10:08 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 28 Aug 2014 14:33:30 -0400 "John W. Linville" <linville@tuxdriver.com> wrote:
>
>> On Wed, Aug 20, 2014 at 12:42:41PM +0300, Andy Shevchenko wrote:
>> > The introduced function is a kind of opposite to string_unescape. We have
>> > several users of such functionality each of them created custom implementation.
>> > The series contains clean up of test suite, adding new call, and switching few
>> > users to use it via %*pE specifier.
>>
>> Any objections?  Do you (Andy) want me to merge this through the
>> wireless tree?
>>
>
> Who is this top-poster and what have you done with John?
>
> I was going to apply them yesterday but in [4/11] Andy said he plans on
> sending out a v5. (v4 actually?)

For now (so far no more comments) it is only couple of trivia fixes
(removing useless comments). Would you like to resend whole series or
just fixup would be enough?

-- 
With Best Regards,
Andy Shevchenko
