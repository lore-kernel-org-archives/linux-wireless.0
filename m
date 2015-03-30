Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35006 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbC3LZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 07:25:58 -0400
Received: by wgdm6 with SMTP id m6so170712014wgd.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2015 04:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150330111428.22198.36611.stgit@potku.adurom.net>
References: <20150330111428.22198.36611.stgit@potku.adurom.net>
Date: Mon, 30 Mar 2015 13:25:56 +0200
Message-ID: <CA+BoTQ=s4M9jt46ta1OKp0vAG6wZvZmbBjPU_kmJYr3F6zuB1A@mail.gmail.com> (sfid-20150330_132601_781815_CFE8DCE9)
Subject: Re: [PATCH] ath10k: fix HTT op backwards compatibility for QCA6174
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 March 2015 at 13:14, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Commit 8348db298496 ("ath10k: add ATH10K_FW_IE_HTT_OP_VERSION") broke QCA6174
> receive side as the HTT ids from ATH10K_FW_HTT_OP_VERSION_MAIN don't have
> HTT_TLV_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND set. Fix this by adding a backwards
> compatibility code which sets HTT op version if it's not set by the firmare

s/firmare/firmware/


> image.
>
> Fixes: 8348db298496 ("ath10k: add ATH10K_FW_IE_HTT_OP_VERSION")
> Reported-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Tested-by: Michal Kazior <michal.kazior@tieto.com>


Michał
