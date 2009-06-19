Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41475 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFSWSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 18:18:18 -0400
Received: by bwz9 with SMTP id 9so2033258bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 15:18:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906192129.26438.mb@bu3sch.de>
References: <83a869cd0906121326r554e6930td9f42d51c2ff4e22@mail.gmail.com>
	<83a869cd0906191217o298a4cc4u114ba6983d34c1e6@mail.gmail.com>
	<200906192129.26438.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 20 Jun 2009 00:18:00 +0200
Message-ID: <69e28c910906191518i3f31753at637da1ca3b1f507c@mail.gmail.com>
Subject: Re: [PATCH] b43 : remove old kidx API
To: Michael Buesch <mb@bu3sch.de>
Cc: gregor kowski <gregor.kowski@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 9:29 PM, Michael Buesch<mb@bu3sch.de> wrote:
> On Friday 19 June 2009 21:17:04 gregor kowski wrote:
>> On 6/12/09, gregor kowski <gregor.kowski@gmail.com> wrote:
>> > Remove old kidx API.
>> > This simplify the code, and fix a potential key overflow.
>> >
>> Michael,
>>
>> any comment on this ?
>> I wait your ack to resubmit tkip hardware support.
>
> If you want my ack, you should probably CC me. I basically don't read the list.
>

Also, given that this is a b43-related issue, CC bcm43xx-dev@lists.berlios.de.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
