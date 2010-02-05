Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f189.google.com ([209.85.223.189]:36358 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0BERrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 12:47:45 -0500
Received: by iwn27 with SMTP id 27so134073iwn.5
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 09:47:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100205165726.GA1496@holoscopio.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <20100205165726.GA1496@holoscopio.com>
Date: Fri, 5 Feb 2010 09:47:44 -0800
Message-ID: <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh mode
From: Andrey Yurovsky <andrey@cozybit.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Feb 5, 2010 at 8:57 AM, Thadeu Lima de Souza Cascardo
<cascardo@holoscopio.com> wrote:
> After doing the "station new" command, I can do a "station dump" and get
> my newly added station. So, I think this is ready for commit. And then,
> we need to sort out both the WARNING and the panic for the Minstrel in
> other patches too.

Just to be clear, what are you trying to do here?  Are you manually
populating the peer links (stations) list?  If so, why?  Thanks,

  -Andrey
