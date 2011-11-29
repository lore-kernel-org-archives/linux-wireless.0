Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53828 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1K2PPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 10:15:02 -0500
Received: by vcbfk14 with SMTP id fk14so4694773vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 07:15:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <877h2jh1ux.fsf@purkki.adurom.net>
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com> <877h2jh1ux.fsf@purkki.adurom.net>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 29 Nov 2011 10:14:38 -0500
Message-ID: <CAB=NE6VxhGoczNxocUpvPdLYpcP7ionisQytW61O-e7pMjp7vw@mail.gmail.com> (sfid-20111129_161509_561172_84CB6618)
Subject: Re: [PATCH 0/5] wireless: fix set tx power
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 29, 2011 at 1:36 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com> writes:
>
>> The driver maintainers have approved of these now except for brcm80211.
>> I should note that Kalle indicated he was going to queue up the ath6kl
>> patch though so not sure if you want to wait for his patch or just suck
>> mine in.
>
> John, please don't take the ath6kl patch as it's already in ath6kl.git:
>
> https://github.com/kvalo/ath6kl/commit/b992a28557afdcabcee7d8af88471dddfe791c11
>
>> I think it makes sense to roll these in together as a series,
>
> I don't see any benefit from this.
>
>> the rebase that Kalle would do shouldn't be impacted by this I think.
>
> I don't rebase ath6kl.git unless absolutely necessary. And I prefer that
> ath6kl patches would go through ath6kl.git, I get less conflicts that
> way.

Alrighty, then the others can be sucked in.

  Luis
