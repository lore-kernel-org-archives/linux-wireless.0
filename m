Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:14464 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755463AbeFSHTz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 03:19:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Govind Singh <govinds@codeaurora.org>
CC: Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "david.brown@linaro.org" <david.brown@linaro.org>,
        "andy.gross@linaro.org" <andy.gross@linaro.org>
Subject: Re: [PATCH v2 0/6]  *** Add support for wifi QMI client driver ***
Date: Tue, 19 Jun 2018 07:13:37 +0000
Message-ID: <87muvrdza9.fsf@qca.qualcomm.com> (sfid-20180619_092011_977161_8E483D74)
References: <20180605123304.31969-1-govinds@codeaurora.org>
        <20180619021742.GA17220@rodete-desktop-imager.corp.google.com>
        <974e34efd334d921e49d08df879c1b97@codeaurora.org>
In-Reply-To: <974e34efd334d921e49d08df879c1b97@codeaurora.org> (Govind Singh's
        message of "Tue, 19 Jun 2018 09:36:05 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> 3) once supported pd info in known to Q6, tftp client in Q6
> establishes the connection with tftp server in Q6 for user pd loading.

This sentence doesn't make sense, should it be that the tftp client in
Q6 establishes the connection with the tftp server in user space?

--=20
Kalle Valo=
