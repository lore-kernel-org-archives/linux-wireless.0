Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40624 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbaJVIqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 04:46:45 -0400
Received: by mail-wi0-f180.google.com with SMTP id em10so673042wid.7
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 01:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413899700-10717-2-git-send-email-michal.kazior@tieto.com>
References: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
	<1413899700-10717-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 22 Oct 2014 10:46:43 +0200
Message-ID: <CA+BoTQmr=uZNeqKxoHM5sG2EU7sBfdETXvzuXkNxDjTJ9ANAbg@mail.gmail.com> (sfid-20141022_104657_147599_0A3661BC)
Subject: Re: [PATCH 1/2] ath10k: remove tsf argument from rx_desc tracing
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2014 15:54, Michal Kazior <michal.kazior@tieto.com> wrote:
> Fundamtenally this was wrong. Tsf is only valid
> in first MPDU of a PPDU. This means tsf value was

s/first MPDU/last MPDU/

I must've had a brain fart when writing the commit log yesterday.

@Kalle: Should I re-spin or will you fix it before applying?


Michał
