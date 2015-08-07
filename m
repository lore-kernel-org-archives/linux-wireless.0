Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbbHGM0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 08:26:36 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Postma <jgmpostma@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warning: cast to restricted __le16
References: <1438860112-1786-1-git-send-email-jgmpostma@gmail.com>
	<wrfjpp30bo9s.fsf@redhat.com> <20150807083707.GA3923@goofy_linux.Home>
Date: Fri, 07 Aug 2015 08:26:33 -0400
In-Reply-To: <20150807083707.GA3923@goofy_linux.Home> (Johannes Postma's
	message of "Fri, 7 Aug 2015 09:37:07 +0100")
Message-ID: <wrfj1tff2sjq.fsf@redhat.com> (sfid-20150807_142652_152377_C3285F9E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Postma <jgmpostma@gmail.com> writes:
> On 06/08/15 at 08:21am, Jes Sorensen wrote:
>> 
>> Looks OK to me. Probably worth changing the *(usPtr + index) to be
>> usPtr[index] as well to make the code easier to read.
>> 
>> Jes
>> 
>
> Thank you for reviewing.  I will make a seperate patch for that.  I will
> send it after this one is accepted.  Or should I combine them into a
> patch serie?

Either is fine with me.

Jes
