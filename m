Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37166 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbbKRXop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 18:44:45 -0500
Received: by wmww144 with SMTP id w144so94263975wmw.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2015 15:44:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87oaesyb1s.fsf@kamboji.qca.qualcomm.com>
References: <20151116195551.GD8895@tuxdriver.com>
	<87oaesyb1s.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 18 Nov 2015 23:44:43 +0000
Message-ID: <CABUTiXU-i7u=1Bbmf=RFfEJM3QYedngxnCr+vVdMPr_pFQ+-tw@mail.gmail.com> (sfid-20151119_004448_317165_D4B42556)
Subject: Re: linux-wireless rebased (probably for the last time) on 4.4-rc1
From: Bruno Antunes <baantunes@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 November 2015 at 14:07, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> "John W. Linville" <linville@tuxdriver.com> writes:
>
> > The wireless-testing tree has been rebased on top of 4.4-rc1.  The
> > current head of the tree is eced3b090878ddba643bbed599e6edea4ad90f49.
> > Please update any downstream trees accordingly!
> >
> > It has been almost a year since I turned-over wireless maintenance
> > duties to Johannes and Kalle. At that time I agreed to continue
> > maintaining the wireless-testing tree for the duration of 2015 to help
> > those that were still relying on it. The end of 2015 is coming soon,
> > and with it I intend to stop maintaining wireless-testing.
> >
> > If you are still relying on wireless-testing, then I implore you to
> > find another option to satisfy your needs. If someone would like to
> > continue maintaining wireless-testing yourself, then please contact
> > me and I will attempt to assist you in such a transition.
> >
> > Thanks for all the fish!
>
> Thank you John. I have been using wireless-testing in my main laptop for
> god knows how many years and I hate to see it go. I consider it as the
> safest way to test the latest wireless code as it's just the latest -rc
> release from Linux plus mac80211 and wireless-drivers trees. linux-next
> is just too experimental for me, I don't want that anywhere near my
> laptop :) It would be interesting to know what others think about
> wireless-testing and how much users that tree really has?

Apparently not many...
I’ve been using it for over a year and I agree that Its a very convenient
way for getting the latest code.

>
> I hope we can find some solution and wireless-testing continues to
> exist. Otherwise testing latest wireless code will become more
> difficult.

Is this tree very difficult to maintain?
In case there are no volunteers what will be future options for using
the latest wireless code?
I think I still don't understand the all developer process. The
wireless wiki [1]
says the diagram is out of date, thats obvious, since wireless tree is now
wireless-drivers and the maintainer is Kalle.
wireless-drivers ----> net -----> linux
So what is the process for wireless-testing tree, the merge of linux,
mac80211and wireless-drivers trees?

Regards,
Bruno

[1] https://wireless.wiki.kernel.org/en/developers/process

>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
