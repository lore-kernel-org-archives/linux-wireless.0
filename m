Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51300 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2HIVVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 17:21:53 -0400
Received: by obbuo13 with SMTP id uo13so1188678obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 14:21:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120809170757.748b68bf@mj>
References: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com>
 <20120809173435.GQ3745@lenteja.do-not-panic.com> <CAA2SeNKbBCxPbJmXMyo4-nK2SXL-WcOFQaKDrEM-cxbVrzt7Ew@mail.gmail.com>
 <CAB=NE6V6T0RMSiMZCsUdr85vWMgs4VfJ6HTYHwf+kDQUwQ-mhg@mail.gmail.com> <20120809170757.748b68bf@mj>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 9 Aug 2012 14:21:32 -0700
Message-ID: <CAB=NE6UracUuvGhQcnkfDsi1peNMgvagS0jyYgSvamim4tiLWA@mail.gmail.com> (sfid-20120809_232156_652456_B199CFD5)
Subject: Re: [PATCH v2] ath9k: decrypt_error flag issue
To: Pavel Roskin <proski@gnu.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 9, 2012 at 2:07 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 9 Aug 2012 11:10:38 -0700
> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> wrote:
>
>> And this would lead to .. what? How did you realize this? Can you
>> please resend and add all this information to the commit log message?
>
> Also please use a better subject.  For example:
>
> ath9k: fix decrypt_error initialization in ath_rx_tasklet()
>
> "issue" is too vague.

Also -- what I was getting at is to evaluate whether or not this is an
important fix or critical. To determine if its critical it helps to
understand exactly what negative behavior was observed. If its
critical it can go to stable but I have a feeling this is not
critical. If its not critical and only important although it won't go
to stable I'll still cherry pick it for the stable compat-wireless
releases.

  Luis
