Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f176.google.com ([209.85.222.176]:46259 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab0EZSPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:15:10 -0400
Received: by pzk6 with SMTP id 6so2902415pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:15:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFD6478.8090700@gmail.com>
References: <1274896804-19441-1-git-send-email-justinmattock@gmail.com>
	<AANLkTilII7C41BTshkXyCmAU81LQ3fJF0ogq_BLVv6w-@mail.gmail.com>
	<4BFD636B.3070607@gmail.com> <AANLkTikIfbrD7t122jJG-ODU5qb9sbGVIGrHlNJ7w2ia@mail.gmail.com>
	<4BFD6478.8090700@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 11:14:48 -0700
Message-ID: <AANLkTinjgtKhQJ1UoQPY8aUFxhb3qrKrYjBgAZz1asZ_@mail.gmail.com>
Subject: Re: [PATCH][RESEND] ath9k: Fix ath_print in xmit for hardware reset.
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linville@tuxdriver.com, arnd@arndnet.de,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 11:12 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/26/2010 11:09 AM, Luis R. Rodriguez wrote:
>> On Wed, May 26, 2010 at 11:07 AM, Justin P. Mattock
>> <justinmattock@gmail.com>  wrote:

>>> what about all the signed-off's? should I
>>> resend with all of those, or no?
>
>> I do not get what you are asking.
>
> all the people that gave there 00.02$ on this to
> make it all-good

Heh... no. SOBs are just for the authors of the code. The real purpose
of SOB is explained on Documentation/SubmittingPatches, read
"Developer's Certificate of Origin 1.1".

  Luis
