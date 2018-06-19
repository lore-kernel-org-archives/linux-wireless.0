Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755463AbeFSHRm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 03:17:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 19 Jun 2018 12:47:41 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org
Subject: Re: [PATCH v2 0/6]  *** Add support for wifi QMI client driver ***
In-Reply-To: <87muvrdza9.fsf@qca.qualcomm.com>
References: <20180605123304.31969-1-govinds@codeaurora.org>
 <20180619021742.GA17220@rodete-desktop-imager.corp.google.com>
 <974e34efd334d921e49d08df879c1b97@codeaurora.org>
 <87muvrdza9.fsf@qca.qualcomm.com>
Message-ID: <373f5fb7f2790f4037dc004c3acb09d5@codeaurora.org> (sfid-20180619_091810_279559_D7FF6B19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 2018-06-19 12:43, Kalle Valo wrote:
> Govind Singh <govinds@codeaurora.org> writes:
> 
>> 3) once supported pd info in known to Q6, tftp client in Q6
>> establishes the connection with tftp server in Q6 for user pd loading.
> 
> This sentence doesn't make sense, should it be that the tftp client in
> Q6 establishes the connection with the tftp server in user space?

Yes, you are right. TFTP server is running in apps user-space and client 
on Q6 root pd.

BR,
Govind
