Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52961
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965AbXGaWQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 18:16:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: iwl: large integer implicitly truncated to unsigned
Date: Wed, 1 Aug 2007 00:16:19 +0200
Cc: linux-wireless@vger.kernel.org
References: <200707312354.10118.mb@bu3sch.de> <1ba2fa240707311511y620b205p21cc1b3963e0ef77@mail.gmail.com>
In-Reply-To: <1ba2fa240707311511y620b205p21cc1b3963e0ef77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708010016.19365.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 August 2007 00:11:32 Tomas Winkler wrote:
> On 8/1/07, Michael Buesch <mb@bu3sch.de> wrote:
> > Are you aware of these warnings in current wireless-dev?
> >
> > drivers/net/wireless/iwl-base.c:2061: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2062: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2063: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2064: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2065: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2071: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2072: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2073: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2074: warning: large integer implicitly truncated to unsigned type
> > drivers/net/wireless/iwl-base.c:2075: warning: large integer implicitly truncated to unsigned type
> >
> Haven't seen this one. What machine are you running compilation? 64bit maybe?

32bit PPC with gcc 4.1.2

-- 
Greetings Michael.
