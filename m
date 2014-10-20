Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42488 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaJTNcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:32:36 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so7179572wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:32:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413809925-4352-8-git-send-email-michal.kazior@tieto.com>
References: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
	<1413809925-4352-8-git-send-email-michal.kazior@tieto.com>
Date: Mon, 20 Oct 2014 15:32:34 +0200
Message-ID: <CA+BoTQ=2JJA8p0EmF7h3OdisZBdi26A87qW4Hv_=AD-bS=u9Ug@mail.gmail.com> (sfid-20141020_153239_788873_F0D529CF)
Subject: Re: [PATCH 7/7] ath10k: implement wmi-tlv backend
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 October 2014 14:58, Michal Kazior <michal.kazior@tieto.com> wrote:
> Latest firmware revision introduced a new WMI ABI
> called wmi-tlv. It is not a tlv strictly speaking
> but something that resembles it because it is
> ordered and may have duplicate id entries.
>
> This will be used by new hardware eventually.

Ok, so I forgot to squash a few things here:
 * pktlog impl. for wmi-tlv
 * more event id defs
 * more wmi-tlv specific event implementations

I can probably do a follow up later instead of re-spinning if it's okay.


Michał
