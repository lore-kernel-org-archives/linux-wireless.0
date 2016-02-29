Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbcB2Xvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:51:40 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 106/113] rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com>
	<CAGRGNgUYaoRoXAXOcdyxwnFNhW15_D=HGDVHVd5UAVVqS+h5MQ@mail.gmail.com>
Date: Mon, 29 Feb 2016 18:51:37 -0500
In-Reply-To: <CAGRGNgUYaoRoXAXOcdyxwnFNhW15_D=HGDVHVd5UAVVqS+h5MQ@mail.gmail.com>
	(Julian Calaby's message of "Tue, 1 Mar 2016 10:46:04 +1100")
Message-ID: <wrfja8mjhy7q.fsf@redhat.com> (sfid-20160301_005142_939988_AF53BA16)
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
>> rtl8723bu_init_bt() is effectively the function enabling RF, so name
>> it appropriately.
>
> Should this be merged into the patches that introduce these functions?

Again, this would be rewriting history and simply cause me to fight a
pile of patch conflicts rebasing things, for no gain, and at the risk of
introducing new errors in the process.

Jes
