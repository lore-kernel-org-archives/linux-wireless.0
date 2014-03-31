Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61821 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaCaLkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:40:20 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so3115458wib.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 04:40:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396263984.4478.13.camel@dubbel>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	<1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	<1396259841-6359-2-git-send-email-michal.kazior@tieto.com>
	<1396263984.4478.13.camel@dubbel>
Date: Mon, 31 Mar 2014 13:40:17 +0200
Message-ID: <CA+BoTQnN8qAmFLe9WgX_zjjy+QrphOhixPWX+CPWij4SJLK7vw@mail.gmail.com> (sfid-20140331_134029_983384_E5EFCC54)
Subject: Re: [PATCH v3 1/4] mac80211: fix CSA tx queue locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2014 13:06, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2014-03-31 at 11:57 +0200, Michal Kazior wrote:
>> It was possible for tx queues to be stuck locked
>
> I would still prefer to use "stopped" instead of locked here (and in the
> subject).  But that's just me...

Ah, I totally missed this one.


>> if AP CSA finalization failed. In that case
>> stop_ap nor do_stop woke the queues up.
>
> Maybe "In that case *neither* stop_ap nor do_stop"...?

I'll respin later unless Johannes decides it's fine as it is.


Michał
