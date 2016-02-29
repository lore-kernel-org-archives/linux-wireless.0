Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbcB2Xwy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:52:54 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 111/113] rtl8xxxu: Print a warning if flushing the FIFO fails
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-112-git-send-email-Jes.Sorensen@redhat.com>
	<CAGRGNgWmnQMRbDzBTDp36DY96Svy_phVBASNHE8frp51O1S20g@mail.gmail.com>
Date: Mon, 29 Feb 2016 18:52:52 -0500
In-Reply-To: <CAGRGNgWmnQMRbDzBTDp36DY96Svy_phVBASNHE8frp51O1S20g@mail.gmail.com>
	(Julian Calaby's message of "Tue, 1 Mar 2016 10:48:17 +1100")
Message-ID: <wrfj60x7hy5n.fsf@redhat.com> (sfid-20160301_005256_948444_A911CFB0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Jes,
>
> On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Only print a warning if the FIFO flush fails, as opposed to printing
>> the status unconditionally.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Should this be squashed into the previous patch?

If you want to have the whole set reposted for a nitpick, sure. If Kalle
prefers to squash the two together, I am fine with that.

Jes
