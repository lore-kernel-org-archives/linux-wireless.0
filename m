Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slow2-v.mail.gandi.net ([217.70.178.89]:49377 "EHLO
	slow2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYEPIzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 04:55:38 -0400
Received: from relay4-v.mail.gandi.net (relay4-v.mail.gandi.net [217.70.178.78])
	by slow2-v.mail.gandi.net (Postfix) with ESMTP id 91E6721E786
	for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 10:40:44 +0200 (CEST)
Message-ID: <20080516104021.18775zzb3wj3y10k@mobydick.mine.nu> (sfid-20080516_105542_224500_A843EF2F)
Date: Fri, 16 May 2008 10:40:21 +0200
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>, j@w1.fi,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostap: procfs fix for hostap_fw.c
References: <20080506152354.GA3680@mobydick> <1210592626.3372.6.camel@dv>
	<20080513004345.GB26418@tuxdriver.com>
In-Reply-To: <20080513004345.GB26418@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 May 2008, "John W. Linville" <linville@tuxdriver.com> wrote:
> On Mon, May 12, 2008 at 07:43:46AM -0400, Pavel Roskin wrote:
>> On Tue, 2008-05-06 at 17:23 +0200, Mathieu Chouquet-Stringer wrote:
>> > Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
>>
>> Acked-off-by: Pavel Roskin <proski@gnu.org>
>>
>> If a more concise description needs to be written, I can do it.
>
> If you don't mind, I would appreciate a more concise description.
> I appreciate the full description of the bug, but I think it is a
> bit much for the changelog as-is.

What about something like this:
"registers" was wrongly created under /proc which was generating warning
during module removal and warning of duplicates objects in /proc after
module reloading.   The file now lies in /proc/net/hostap, where it was
meant to be.

-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
             The sun itself sees not till heaven clears.
               -- William Shakespeare --
