Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34947 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbbCZJ1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 05:27:53 -0400
Received: by wibbg6 with SMTP id bg6so56551082wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 02:27:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426849379-7562-2-git-send-email-marek.puzyniak@tieto.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-2-git-send-email-marek.puzyniak@tieto.com>
Date: Thu, 26 Mar 2015 10:27:52 +0100
Message-ID: <CA+BoTQm74JDvMk=G2Hot7h4v4gU4gRh8JH0K=1yhMa_UGQ4e0A@mail.gmail.com> (sfid-20150326_102801_833539_ADE9F701)
Subject: Re: [PATCH v4 1/6] ath10k: unify tx mode and dispatch
From: Michal Kazior <michal.kazior@tieto.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 March 2015 at 12:02, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
>
> There are a few different tx paths depending on
> firmware and frame itself.
>
> Creating a uniform decision will make it possible
> to switch between different txmode easier, both
> for testing and for future features as well.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
[...]

This patch apparently breaks AP operation. I need to investigate this.


Michał
