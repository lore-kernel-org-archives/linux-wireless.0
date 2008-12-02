Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:19519 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYLBWNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 17:13:45 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1319983yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 14:13:44 -0800 (PST)
Message-ID: <43e72e890812021413j3c0473a6r7a8a30e7d2602410@mail.gmail.com> (sfid-20081202_231350_215451_9D6714CF)
Date: Tue, 2 Dec 2008 14:13:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [PATCH 0/3] ath9k: several fixes ported to 2.6.27
Cc: stable@kernel.org, sfr@canb.auug.org.au,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <20081202212704.GA31723@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
	 <20081202212704.GA31723@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 1:27 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Dec 02, 2008 at 12:51:19PM -0800, Luis R. Rodriguez wrote:
>> This fixes a few issues seen on MacBook Pros:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=11811
>>
>> I've ported them to 2.6.27 to help with them being applied sooner.
>
> What do you mean by "sooner"?  They need to be in Linus's tree before we
> can add them to the 2.6.27-stable tree.  Please let us know when that
> happens, and what the git ids of them are, so we can add them to the
> next -stable release.

Heh, well once applied there it may not apply on 27, so by sooner I
mean that you don't have to do backport work as I did it for you.

  Luis
