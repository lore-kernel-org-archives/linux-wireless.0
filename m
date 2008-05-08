Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:29446 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYEHXaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 19:30:04 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1415715waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 16:30:02 -0700 (PDT)
Message-ID: <1ba2fa240805081630r3fdad2d7ya0e1e78fa69cb4ea@mail.gmail.com> (sfid-20080509_012904_399597_8A683F79)
Date: Fri, 9 May 2008 02:30:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: iwlwifi and tx info in skb->cb
Cc: johannes@sipsolutions.net, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080508.162059.42870104.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com>
	 <1210285845.3547.81.camel@johannes.berg>
	 <1ba2fa240805081616l3f49d770pefd517076a06b3ef@mail.gmail.com>
	 <20080508.162059.42870104.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2008 at 2:20 AM, David Miller <davem@davemloft.net> wrote:
> From: "Tomas Winkler" <tomasw@gmail.com>
>  Date: Fri, 9 May 2008 02:16:14 +0300
>
>
>  > On Fri, May 9, 2008 at 1:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > >  Anyway, with the changes davem and I are making to actually save the
>  > >  *extra* copy we should be doing well. That's where you want to look for
>  > >  improvements.
>  >
>  > This is just for the bridging case, isn't it?
>
>  No, all cases.
>
>  We're repeating a lot of information for you, over and over
>  again, it seems.  Developers often find this frustrating,
>  especially when they are trying to get their own work done.
>
Hey it's just second time and I explicitly wrote I will read the email
again, you choose to answer... anyway thanks for the answer :)

Tomas
