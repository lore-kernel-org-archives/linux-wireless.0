Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:54311 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbXGaWU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 18:20:57 -0400
Received: by wx-out-0506.google.com with SMTP id h31so16794wxd
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 15:20:56 -0700 (PDT)
Message-ID: <1ba2fa240707311520w1dee7c24jd5696877b41653a0@mail.gmail.com>
Date: Wed, 1 Aug 2007 01:20:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: iwl: large integer implicitly truncated to unsigned
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708010016.19365.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200707312354.10118.mb@bu3sch.de>
	 <1ba2fa240707311511y620b205p21cc1b3963e0ef77@mail.gmail.com>
	 <200708010016.19365.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/1/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Wednesday 01 August 2007 00:11:32 Tomas Winkler wrote:
> > On 8/1/07, Michael Buesch <mb@bu3sch.de> wrote:
> > > Are you aware of these warnings in current wireless-dev?
> > >
> > > drivers/net/wireless/iwl-base.c:2061: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2062: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2063: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2064: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2065: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2071: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2072: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2073: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2074: warning: large integer implicitly truncated to unsigned type
> > > drivers/net/wireless/iwl-base.c:2075: warning: large integer implicitly truncated to unsigned type
> > >
> > Haven't seen this one. What machine are you running compilation? 64bit maybe?
>
> 32bit PPC with gcc 4.1.2
>
Hmm,  I'll try to cross compile it tomorrow.
> --
> Greetings Michael.
>
