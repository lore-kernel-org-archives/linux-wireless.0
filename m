Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37107 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0K2WnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 17:43:12 -0500
MIME-Version: 1.0
In-Reply-To: <4CF42C17.2070500@openwrt.org>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
 <20101129060732.5130.qmail@stuge.se> <4CF42C17.2070500@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 29 Nov 2010 14:42:50 -0800
Message-ID: <AANLkTikkiizJ0YkcAgxKvdpbtmsZQuAL5AtiWpvnj0hK@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to ath_debug
To: Felix Fietkau <nbd@openwrt.org>
Cc: peter@stuge.se, ath9k-devel@lists.ath9k.org,
	linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 2:41 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-11-29 7:07 AM, Peter Stuge wrote:
>> Luis R. Rodriguez wrote:
>>> On Sun, Nov 28, 2010 at 3:53 PM, Joe Perches <joe@perches.com> wrote:
>>> > Make the function name match the function purpose.
>>> > ath_debug is a debug only facility.
>>> > ath_print seems too generic a name for a debug only use.
>>>
>>> Nack, I don't see the point.
>>
>> The point is to improve readability. I like the patch.
> And how exactly does this improve readability? Don't get me wrong, I
> generally like to see more cleanups merged to the ath/ath9k drivers
> (they do need it, after all).
>
> But in my opinion, simple renaming churn like this does nothing but
> annoy people who want to get other work done at the same time.
> Consider the large number of lines touched (and the potential merge
> conflicts with other code because of that), relative to the microscopic
> aesthetic gain (if any).
>
> Instead I'd like to see more cleanups that go beyond trivial function
> renames.

Thanks for putting it so clearly. Agreed.

  Luis
