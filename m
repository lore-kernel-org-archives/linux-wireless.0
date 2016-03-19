Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbcCSD6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 23:58:22 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Driver Project Developer List
	<driverdev-devel@linuxdriverproject.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: refresh TODO for rtl8723au
References: <1458321324-16906-1-git-send-email-xose.vazquez@gmail.com>
	<wrfjlh5fk7i4.fsf@redhat.com> <1458325693.26915.23.camel@perches.com>
Date: Fri, 18 Mar 2016 23:58:18 -0400
In-Reply-To: <1458325693.26915.23.camel@perches.com> (Joe Perches's message of
	"Fri, 18 Mar 2016 11:28:13 -0700")
Message-ID: <wrfjbn6bi0f9.fsf@redhat.com> (sfid-20160319_045845_547991_27D2A4F1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Fri, 2016-03-18 at 13:42 -0400, Jes Sorensen wrote:
>> Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
>> > People should not waste time and energy working on this staging driver.
>> > A replacement(rtl8xxxu) using the kernel wireless stack already was merged
>> > in the 4.3 kernel.
> []
>> >  drivers/staging/rtl8723au/TODO | 3 +++
>> Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> why not git rm drivers/staging/rtl8723au/ ?

Because you don't just pull the rug out under people. I plan to mark it
obsolete and then remove it in a follow-on release.

Jes
