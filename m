Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:44094 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752573AbdJ3IkW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 04:40:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Revert "ath10k: fix napi_poll budget overflow"
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1509262876-10944-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1509262876-10944-1-git-send-email-kvalo@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <84b6d93b325741f7a6d24d1252f93149@euamsexm01a.eu.qualcomm.com> (sfid-20171030_094049_515149_6E70E507)
Date: Mon, 30 Oct 2017 09:40:16 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> Thorsten reported on <fa6e3ee2-91b5-a54b-afe3-87f30aac7a48@leemhuis.info> that
> commit c9353bf483d3 made ath10k unstable with QCA6174 on his Dell XPS13 (9360)
> with an error message:
> 
> ath10k_pci 0000:3a:00.0: failed to extract amsdu: -11
> 
> It only seemed to happen with certain APs, not all, but when it happened the
> only way to get ath10k working was to switch the wifi off and on with a hotkey.
> 
> As this commit made things even worse (a warning vs breaking the whole
> connection) let's revert the commit for now and while the issue is being fixed.
> 
> Link: http://lists.infradead.org/pipermail/ath10k/2017-October/010227.html
> Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-current branch of ath.git, thanks.

e48e9c429a95 Revert "ath10k: fix napi_poll budget overflow"

-- 
https://patchwork.kernel.org/patch/10031233/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
