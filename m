Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58401 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaH2G3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 02:29:36 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so2016971wid.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 23:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877g1ru9tl.fsf@kamboji.qca.qualcomm.com>
References: <1409231135-16233-1-git-send-email-michal.kazior@tieto.com>
	<877g1ru9tl.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 29 Aug 2014 08:29:35 +0200
Message-ID: <CA+BoTQ=WArssWs9L4QfoJRtKbTfWZL88mELQGT76G4RKz-jpJw@mail.gmail.com> (sfid-20140829_082939_767972_845FDDB3)
Subject: Re: [PATCH] ath10k: add device/driver strings to tracepoints
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 August 2014 07:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This makes it easier to log and debug via tracing
>> with more than 1 ath10k device on a system.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> In ath-next-test I had a simple conflict in wmi.c. Please check my
> conflict resolution:
>
> https://github.com/kvalo/ath/commit/d4bcfa9487e0837fdaf01645ade15acbadc3873c

Looks good, thanks.


Michał
