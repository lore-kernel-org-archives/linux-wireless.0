Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36128 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3EWQtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 12:49:39 -0400
Received: by mail-wi0-f179.google.com with SMTP id hq7so2210011wib.12
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2013 09:49:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <002301ce57cc$dcaeef40$960ccdc0$@acksys.fr>
References: <002301ce57cc$dcaeef40$960ccdc0$@acksys.fr>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Thu, 23 May 2013 09:49:17 -0700
Message-ID: <CACcxo+rJcr3sL_8NU8ygyzvx0eqN+5gKtz6kfcX=QH6pNphCMw@mail.gmail.com> (sfid-20130523_184954_400271_9E5AAB61)
Subject: Re: How to set basic rates in mesh mode?
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tosoni,

On Thu, May 23, 2013 at 8:47 AM, Jean-Pierre Tosoni <jp.tosoni@acksys.fr> wrote:
> Hi all,
>
> Is there a way to change the basic rates set in mesh mode ?
> (so that broadcasts and ACKs could be sent faster)
>
Not with the current ToT. But patches to support this feature have
been sent and is waiting to get merged.

If you would like to use the feature now, you could find these patches here.

1. https://patchwork.kernel.org/patch/2552611/
2. https://patchwork.kernel.org/patch/2552621/
and 3. https://patchwork.kernel.org/patch/2552641/

Thanks,
Ashok
> - iw does not do this, and cfg80211 rejects NL80211_CMD_SET_BSS for mesh
> interfaces, I cannot figure out another way ?
>
> Regards
> j.p. Tosoni
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
