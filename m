Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab2EONny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:43:54 -0400
Received: by bkcji2 with SMTP id ji2so4811282bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:43:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337089231.4189.47.camel@cumari.coelho.fi>
References: <1337089126-11570-1-git-send-email-arik@wizery.com> <1337089231.4189.47.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 15 May 2012 16:43:38 +0300
Message-ID: <CA+XVXfcD=5s-kjzJtYuNuP3zxqYyeV3=CgpfF16LkiY0v2cuCA@mail.gmail.com> (sfid-20120515_154358_568344_686F45CF)
Subject: Re: [PATCH 1/3] wlcore: flush tx on CHANGE_CHANNEL
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 4:40 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2012-05-15 at 16:38 +0300, Arik Nemtsov wrote:
>> From: Eliad Peller <eliad@wizery.com>
>>
>> On CHANGE_CHANNEL indication, we should flush all the
>> queued tx frames, so they will be sent on the correct
>> (current) channel.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> If this patch is From: Eliad, you need his s-o-b tag here too (assuming
> he wants to sign it, of course ;).

Sure we'll add it.
