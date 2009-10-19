Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:44161 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZJSIgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 04:36:44 -0400
Received: by iwn8 with SMTP id 8so2150392iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 01:36:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910190940.52830.hs4233@mail.mn-solutions.de>
References: <200910190940.52830.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 19 Oct 2009 17:36:29 +0900
Message-ID: <43e72e890910190136s21703864i3002f2a31f940111@mail.gmail.com>
Subject: Re: [PATCH] libertas: remove unused 11d code
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2009 at 4:40 PM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> Most of the 11d code was protected with an "if (priv->enable11d)" clause.
> But there was no code that anywhere that was able to set this
> variable to true. So all 11d code was dead for almost a year and no one
> complained. That's enought incentive to remove this code.
>
> Besides removing old cruft, we gain back the 11d capability in a common way
> when we merge the cfg80211 functionality.
>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Is the countryinfo->countrycode not usable for regulatory_hint_11d() ?

  Luis
