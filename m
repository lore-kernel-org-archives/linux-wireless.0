Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36383 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbbKRVVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 16:21:33 -0500
MIME-Version: 1.0
In-Reply-To: <1447857966-19560-11-git-send-email-kvalo@codeaurora.org>
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
	<1447857966-19560-11-git-send-email-kvalo@codeaurora.org>
Date: Wed, 18 Nov 2015 23:21:31 +0200
Message-ID: <CANUX_P0TpjGhvvo3EyPqLr6An4ERrgDCTY-suzsdjZY-e_NgcA@mail.gmail.com> (sfid-20151118_222151_164126_F07123DB)
Subject: Re: [PATCH v2 10/27] iwlwifi: move under intel vendor directory
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, Nov 18, 2015 at 4:45 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Part of reorganising wireless drivers directory and Kconfig.
>

I am sorry but I'd prefer to wait with this. We have a big machinery
of scripts / builds and alike that will break. I did give a heads up a
while ago to the people in charge of these scripts that this change is
on the way, but they are not done yet. I will get back to them and ask
them when we can be ready for such a change and then it'll come from
my tree. I promise to try to make it happen ASAP.
The above is relevant for iwlwifi only. As far as I am concerned, you
can move the iwlwifi and ipw.

Thank you.

> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  MAINTAINERS                                        |    2 +-
