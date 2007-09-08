Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:32542 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbXIHIUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 04:20:31 -0400
Received: by py-out-1112.google.com with SMTP id u77so1403919pyb
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 01:20:30 -0700 (PDT)
Message-ID: <1ba2fa240709080120j1c67dbc8m14c91529085cc19a@mail.gmail.com>
Date: Sat, 8 Sep 2007 11:20:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi sparse warnings with __CHECK_ENDIAN__
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1189237311.4506.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1189100027.28781.104.camel@johannes.berg>
	 <1ba2fa240709080037p44516f1eu7040bd4424a29f8c@mail.gmail.com>
	 <1189237311.4506.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2007-09-08 at 10:37 +0300, Tomas Winkler wrote:
> > I'm not sure that you are running latest iwlwifi.
>
> I have the latest wireless-dev.
>

The version in wireless-dev is 0.1.8 and we are 0.1.15 on stable and
1.1.0 on the development branch. Looks like Yi's patches weren't
synced for a while.

Tomas
