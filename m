Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:63416 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZJHE7D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 00:59:03 -0400
Received: by iwn8 with SMTP id 8so3233876iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 21:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091008043426.GA5760@bombadil.infradead.org>
References: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
	<1254878351-32433-2-git-send-email-lrodriguez@atheros.com>
	<20091008043426.GA5760@bombadil.infradead.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 8 Oct 2009 00:58:06 -0400
Message-ID: <43e72e890910072158p6286f7f2va4954eb870ec9918@mail.gmail.com>
Subject: Re: [PATCH 1/6] ath9k: move common->debug_mask setting to
	ath_init_softc()
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	vasanth@atheros.com, Sujith.Manoharan@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 8, 2009 at 12:34 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Oct 06, 2009 at 09:19:06PM -0400, Luis R. Rodriguez wrote:
>> What this means is we can enable now debug prints without
>> requiring CONFIG_ATH9K_DEBUG.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
>> +MODULE_PARM_DESC(ath9k_debug, "Debugging mask");
>
> John, as sujith notes, this should be MODULE_PARM_DESC(debug ...
>
> Thanks sujith.
>
> so here's v2:

Oh this is merged already -- either you can take this one or I'll send
a fix now.

  Luis
