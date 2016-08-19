Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43656 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752581AbcHSKH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 06:07:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1,V3] ath9k: consider return code on
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <490b6e07-d357-7985-8796-80125322e82e@riverbed.com>
To: Eduardo Abinader <eduardo.abinader@riverbed.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Message-ID: <b84038d79a61493baeade432d4869494@euamsexm01a.eu.qualcomm.com> (sfid-20160819_120729_861454_0830260C)
Date: Fri, 19 Aug 2016 12:07:20 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eduardo Abinader <eduardo.abinader@riverbed.com> wrote:
> just to comply with current ath9k_hw_nvram_read to return value, hence
> behaving reacting accordingly.
> 
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

a5d268277ad5 ath9k: consider return code on

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9249821/
