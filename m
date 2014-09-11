Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:53790 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIKGEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 02:04:37 -0400
Received: by mail-we0-f169.google.com with SMTP id w61so4725791wes.28
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2014 23:04:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87sijz5u6q.fsf@kamboji.qca.qualcomm.com>
References: <1409827005-3777-1-git-send-email-michal.kazior@tieto.com>
	<87sijz5u6q.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 11 Sep 2014 08:04:36 +0200
Message-ID: <CA+BoTQnc9Vvedo5bwzvoRbEAiu=xcTbagEmxUDJ=9+Uva_UbWg@mail.gmail.com> (sfid-20140911_080440_966328_F45F49ED)
Subject: Re: [PATCH v3] ath10k: fix debugfs_create_dir() checking
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 September 2014 18:14, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
[...]
>> Since mine is just an extra precaution feel free
>> to drop all but the first paragraph of my commit
>> message if you want to.
>
> Thanks, I just left the first paragraph like you recommended. Also I had
> a conflict with this patch, please double check my resolution in
> ath-next-test:
>
> https://github.com/kvalo/ath/commit/bee6d655eefe488b76998c9c0018a4e6b0828de6

Looks good, thanks!


Michał
