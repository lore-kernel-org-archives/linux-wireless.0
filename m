Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35914 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbeASIlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 03:41:50 -0500
Received: by mail-yw0-f193.google.com with SMTP id q6so360104ywg.3
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 00:41:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87607yxnfh.fsf@purkki.adurom.net>
References: <cover.1516315624.git.lorenzo.bianconi@redhat.com>
 <f46c90a50429201056419aae168a836fcc406f47.1516315624.git.lorenzo.bianconi@redhat.com>
 <87607yxnfh.fsf@purkki.adurom.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Fri, 19 Jan 2018 09:41:49 +0100
Message-ID: <CAJ0CqmWcChnkXBUYvV24f2uQG7d7XYGeXPJBKhdinvhDehuOLg@mail.gmail.com> (sfid-20180119_094153_667778_5C5DDACB)
Subject: Re: [PATCH 1/2] mt76x2: init: disable tbtt tasklet during device cleanup
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>
> No empty commit logs, please. At least the commit log should answer the
> question "Why?". For example, are you fixing a reported bug or are you
> fixing is a theoretical issue you found during code review? What kind of
> symtomps does this bug have?
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why

Ack, I will wait for some feedbacks and then I will respin a v2 with a
proper commit log. Thanks.
Regards,

Lorenzo

>
> --
> Kalle Valo
