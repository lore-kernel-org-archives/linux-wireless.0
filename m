Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53773 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab0FPPsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 11:48:52 -0400
Received: by pva4 with SMTP id 4so717240pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 08:48:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100616081227.GA1118@boggieman>
References: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com>
	<20100616081227.GA1118@boggieman>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 16 Jun 2010 08:48:22 -0700
Message-ID: <AANLkTikR9zrXC-ziuWMgRAdhOodDDib-KZzpvDzKjAHJ@mail.gmail.com>
Subject: Re: [PATCH 2.6.32.y] ath9k: re-enable ps by default for new single
	chip families
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: stable@kernel.org, greg@kroah.com, linux-wireless@vger.kernel.org,
	Peter Stuge <peter@stuge.se>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 1:12 AM, Kristoffer Ericson
<kristoffer.ericson@gmail.com> wrote:
> On Tue, Jun 15, 2010 at 06:19:19PM -0400, Luis R. Rodriguez wrote:
>> commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.
>>
>> The newer single chip hardware family of chipsets have not been
>> experiencing issues with power saving set by default with recent
>> fixes merged (even into stable). The remaining issues are only
>> reported with AR5416 and since enabling PS by default can increase
>> power savings considerably best to take advantage of that feature
>> as this has been tested properly.
>
> I havent had any issues lately. But that said Ive moved on to
> 2.6.33, 2.6.34 which seems to work fine. Believe you set
> to disabled by default on those?

2.6.33 and up all have PS enabled by default for all single chip
families. For AR5416 and related chipsets, its left disabled as it was
on 2.6.32 right now. The patch is intended only for 2.6.32.y as the
other kernels 2.6.33.y and up already have the same patch.

  Luis
